class EventController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authorize_event, only: %i[show]

  def create
    @event = Event.new(event_params)
    @event.created_at = Time.now.utc
    if @event.validate
      @event.save!
      Rails.logger.info(event: "created_event", object: @event)
      render json: "{'message': 'created'}", status: 204
      return
    end

    errors = []
    if @event.errors.messages.any?
      errors = @event.errors.messages.map { |err| "Field Name: #{err[0]} -- Problems: #{err[1].split(',')}"}
    end
    render status: 400, json: JSON.parse(errors.to_s)
  end

  def show
    @event = Event.find_by(id: params[:id])
  end

  def index
    @events = Event.all
  end

  private

  def event_params
    params.require(:event).permit(:pet_id, :kind, :happened_at)
  end
end
