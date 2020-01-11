class ApplicationController < ActionController::Base
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
end
