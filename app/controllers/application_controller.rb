class ApplicationController < ActionController::Base
  before_action :authorized
  skip_before_action :authorized, only: %i[healthcheck login logout crash except]

  unless Rails.application.config.consider_all_requests_local
    rescue_from StandardError do |err|
      Rails.logger.error(event: "unhandled_exception",
                         message: err.message,
                         original_url: request.original_url,
                         remote_ip: request.remote_ip,
                         method: request.request_method,
                         path: request.fullpath,
                         format: request.format.to_s,
                         query_params: request.query_parameters,
                         backtrace: Rails.backtrace_cleaner.clean(err.backtrace))

      redirect_to err_internal_path
    end
  end

  def crash
    render json:'{"err":"manual"}', status: 500
  end

  def except
    raise "manually raised error"
  end

  def healthcheck
    render json: "{'message': 'ok', 'config':'#{APP_CONFIG}'}", status: 200
  end

  def login
    redirect_to pet_index_path if logged_in?

    if request.post?
      data = params.require(:user).permit(:email, :password)

      @user = User.find_by(email: data[:email])
      if @user && @user.authenticate(data[:password])
        payload = JwtUtils.get_default_payload(@user.id)
        token = JwtUtils.encode(payload)
        cookies[APP_CONFIG['auth_key']] = token
  
        redirect_to dashboard_path
        return
      end
  
      @user = User.new(email: data[:email])
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
      redirect_to login_path 
      return
    end

    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)
    if pet.nil?
      redirect_to pet_index_path
      return
    end

    unless pet.user.id == @current_user.id
      redirect_to pet_index_path
      return
    end
  end

  def authorize_event
    if !logged_in?
      redirect_to login_path 
      return
    end

    event_id = params[:id]
    event = Event.find_by(id: event_id)
    if event.present? && event.pet.user.id != @current_user.id
      redirect_to pet_index_path
      return
    end
    
    pet_id = params[:pet_id]
    pet = Pet.find_by(id: pet_id)
    if pet.present? && pet.user.id != @current_user.id
      redirect_to pet_index_path
      return
    end
  end

  def render_404
    render json: '{"msg":"record not found"}', status: 404
  end
end
