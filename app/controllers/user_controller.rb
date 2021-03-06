class UserController < ApplicationController
  skip_before_action :authorized, only: %i[new create]

  def new
    @user = User.new
    @timezones = timezones
  end
  
  def create
    @user = User.new(user_params)
    if @user.validate
      begin
        @user.save!
      rescue StandardError => e
        Rails.logger.error(event: "cannot-persist-new-user", error: e, user: @user)
        @user.errors.add(:email, "email is associated with existing account")
        @timezones = timezones

        render "new"
        return 
      end

      # TODO: we probably want to build some sort of dashboard, but for now, let's just send 
      # them where we think makes sense
      redirect_to new_pet_path
      return
    end
    
    @timezones = timezones
    render new_user_path, status: 400
  end

  def edit
    @user = @current_user
    @timezones = timezones
  end

  def update
    if @current_user.update_attributes(user_params)
      redirect_to new_pet_path
      return
    end

    @timezones = timezones
    render :edit, status: 400
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def index
    @users = User.all
  end

  def dashboard
    @pets = @current_user.pets
    @chart_data = {}
    @pets.each do |pet|
      poops = {}
      pees = {}
      Event.for_pet(pet.id).poops.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        poops.merge!({local_time => local_time.strftime("%H:%M")})
      end
      Event.for_pet(@pets.first.id).pees.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        pees.merge!({local_time => local_time.strftime("%H:%M")})
      end
      pet_data = {
        potties: [
          { name: "poops", data: poops },
          { name: "pees", data: pees },
        ],
        poops: [
          { name: "poops", data: poops },
        ],
        pees: [
          { name: "pees", data: pees },
        ]
      }
      @chart_data[pet.id] = pet_data
      # @data = [
      #   {name: "poops", data: poops},
      #   {name: "pees", data: pees},
      # ]
      # @poopdata = [{name:"poops", data: poops}]
      # @peedata = [{name:"pees", data: pees}]
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :timezone)
  end

  def timezones
    ActiveSupport::TimeZone::MAPPING.select{|k,v| v.include? "America"}.map{|tz| tz.last}
  end
end
