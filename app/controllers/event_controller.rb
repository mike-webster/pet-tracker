class EventController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authorize_event, only: %i[show]

  def new
    @event = Event.new()
    @pets = @current_user.pets
    @events = @pets.map{|p| p.events}.flatten
  end

  def create
    @event = Event.new(event_params)
    @event.happened_at = parse_local_time.utc
    @event.created_at = Time.now.utc
    @event.local_time = nil
    if @event.validate
      @event.save!
      Rails.logger.info(event: "created_event", object: @event)
      redirect_to new_event_path
      return
    end

    flash[:error] = @event.errors.messages
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
    params.require(:event).permit(:pet_id, :kind, :happened_at, :local_time)
  end

  def parse_local_time
    Time.new(event_params["local_time(1i)"], event_params["local_time(2i)"], event_params["local_time(3i)"], event_params["local_time(4i)"], event_params["local_time(5i)"]).change(zone: @current_user.timezone)
  end
end
