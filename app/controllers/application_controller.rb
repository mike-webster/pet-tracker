class ApplicationController < ActionController::Base
  before_action :authorized
  skip_before_action :authorized, only: %i[healthcheck login logout]
  def healthcheck
    render json: "{'message': 'ok'}", status: 200
  end

  def login
    if request.post?
      data = params.require(:user).permit(:email, :password)

      @user = User.find_by(email: data[:email])
      if @user && @user.authenticate(data[:password])
        payload = JwtUtils.get_default_payload(@user.id)
        token = JwtUtils.encode(payload)
        cookies[APP_CONFIG['auth_key']] = token
  
        redirect_to new_pet_path
        return
      end
  
      flash.now[:error] = "login failed"
      render status: 401
      return
    end

    @user = User.new
    return
  end 

  def logout
    cookies.delete APP_CONFIG['auth_key'].to_sym
    redirect_to login_path
  end

  def current_user
    token = cookies[APP_CONFIG['auth_key']]
    return if token.nil?
    payload = JwtUtils.decode(token)
    return if payload.nil?
    @current_user = User.find_by(id: payload["user_id"])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to login_path unless logged_in?
  end

  def authorize_pet
    if !logged_in?
      Rails.logger.error(event: "unauthorized", message: "not logged in")
      redirect_to login_path 
      return
    end

    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)
    if pet.nil?
      redirect_to pet_index_path
      Rails.logger.error(event: "unauthorized", message: "pet doesnt exist")
      return
    end

    unless pet.user.id == @current_user.id
      redirect_to pet_index_path
      Rails.logger.error(event: "unauthorized", message: "pet does not belong to user")
      return
    end
    
    Rails.logger.debug(event: "authorized_pet")
  end

  def authorize_event
    if !logged_in?
      redirect_to login_path 
      Rails.logger.error(event: "unauthorized", message: "not logged in")
      return
    end

    event_id = params[:id]
    event = Event.find_by(id: event_id)
    if event.present? && event.pet.user.id != @current_user.id
      redirect_to pet_index_path
      Rails.logger.error(event: "unauthorized", message: "event associated with pet that does not belong to user")
      return
    end
    
    pet_id = params[:pet_id]
    pet = Pet.find_by(id: pet_id)
    if pet.present? && pet.user.id != @current_user.id
      redirect_to pet_index_path
      Rails.logger.error(event: "unauthorized", message: "event - pet does not belong to user")
      return
    end
  end
end
