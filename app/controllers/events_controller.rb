class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @status = "none"
  end

  def new
    @event = Event::Launch.new
  end

  def create
    @event = Event::Launch.new(event_params)

    if (created_event = @event.save!)
      redirect_to event_path(created_event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.expect(event_launch: %i[name match_format number_of_coats number_of_players])
  end
end
