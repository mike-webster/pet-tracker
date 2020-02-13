class PetController < ApplicationController
  before_action :authorize_pet, only: %i[show]

  def new
    @pet = Pet.new
    @pet.birthday = Time.parse("2019-10-12")
  end

  def create
    @pet = Pet.new(pet_params)
    @pet.user = @current_user
    if @pet.validate
      @pet.save!
      redirect_to pet_path(@pet.id)
      return
    end

    render :new, status: 400
  end

  def show
    @pet = Pet.find_by(id: params[:id])
  end

  def index
    @pets = Pet.where(user_id: @current_user.id)
  end

  def events
    @pet = Pet.find_by(id: params[:id])
    @events = @pet.events.default_time_range.sort_by(&:happened_at).reverse
    @events = @pet.events.sort_by(&:happened_at).reverse if @events.empty?
    render "events", layout: false
  end

  def graph
    pet = Pet.find_by(id: params[:id])
    if pet.nil?
      render_404

      return 
    end

    case params[:type]
    when "potties"
      poops = {}
      pees = {}

      Event.for_pet(pet.id).poops.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        poops.merge!({local_time => local_time.strftime("%H:%M")})
      end

      Event.for_pet(pet.id).pees.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        pees.merge!({local_time => local_time.strftime("%H:%M")})
      end

      data = [
        { name: "poops", data: poops },
        { name: "pees", data: pees },
      ]
      render json: @data, status: 200
    when "poos"
      poops = {}

      Event.for_pet(pet.id).poops.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        poops.merge!({local_time => local_time.strftime("%H:%M")})
      end

      render json: [{ name: "poops", data: poops }], statuts: 200
    when "pees"
      pees = {}

      Event.for_pet(@pets.first.id).pees.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        pees.merge!({local_time => local_time.strftime("%H:%M")})
      end

      render json: [{ name: "pees", data: pees }], status: 200
    when "pees-html"
      pees = {}

      Event.for_pet(@current_user.pets.first.id).pees.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        pees.merge!({local_time => local_time.strftime("%H:%M")})
      end
      @data = [{ name: "pees", data: pees }]
      render "graph", status: 200, layout: false
    when "poos-html"
      poops = {}

      Event.for_pet(@current_user.pets.first.id).poops.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        poops.merge!({local_time => local_time.strftime("%H:%M")})
      end
      @data = [{ name: "poos", data: poops }]
      render "graph", status: 200, layout: false
    when "potties-html"
      poops = {}
      pees = {}

      Event.for_pet(pet.id).poops.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        poops.merge!({local_time => local_time.strftime("%H:%M")})
      end

      Event.for_pet(pet.id).pees.in_time_range((Time.now - 5.days), Time.now).each do |e|
        local_time  = e.happened_at.in_time_zone(@current_user.timezone)
        pees.merge!({local_time => local_time.strftime("%H:%M")})
      end

      @data = [
        { name: "poops", data: poops },
        { name: "pees", data: pees },
      ]
      render "graph", status: 200, layout: false
    else
      render_404
      return 
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :kind, :breed, :birthday)
  end
end
