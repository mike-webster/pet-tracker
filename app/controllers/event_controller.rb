class EventController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authorize_event, only: %i[show]

  def new
    @event = Event.new
    @event.happened_at = Time.now.utc
    @pets = @current_user.pets
    @events = @pets.map{|p| p.events}.flatten
  end

  def create
    @event = Event.new(event_params)
    @event.created_at = Time.now.utc
    if @event.validate
      @event.save!
      Rails.logger.info(event: "created_event", object: @event)
      redirect_to new_event_path
      return
    end

    @pets = @current_user.pets
    @events = @pets.map{|p| p.events}.flatten
    render :new, status: 400
  end

  def show
    @event = Event.find_by(id: params[:id])
    render_404 if @event.nil?
  end

  def index
    @events = Event.for_user(@current_user.id)
  end

  private

  def event_params
    params.require(:event).permit(:pet_id, :kind, :happened_at)
  end
end
