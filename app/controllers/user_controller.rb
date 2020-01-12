class UserController < ApplicationController
  skip_before_action :authorized, only: %i[new create]
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.validate
        begin
          @user.save!
        rescue StandardError => e
          Rails.logger.error(event: "cannot-persist-new-user", error: e, user: @user)
          @user.errors.add(:email, "email is associated with existing account")
          flash[:error] = "not sure what happened... #{e}"
          redirect_to new_user_path
          return 
        end

        # TODO: we probably want to build some sort of dashboard, but for now, let's just send 
        # them where we think makes sense
        redirect_to new_pet_path
        return
      end
  
      render :new, status: 400
    end
  
    def show
      @user = User.find_by(id: params[:id])
    end
  
    def index
      @users = User.all
    end
  
    private
  
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
end
