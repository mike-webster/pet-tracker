class ApplicationController < ActionController::Base
  def healthcheck
    render json: "{'message': 'ok'}", status: 200
  end
end
