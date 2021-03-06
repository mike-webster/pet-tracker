class ErrorsController < ApplicationController
  skip_before_action :authorized

  def not_found
    render status: 404
  end

  def internal_error
    render status: 500
  end
end