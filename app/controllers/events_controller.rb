class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event::Launch.new
  end

  def create
    @event = Event::Launch.new(event_params)

    if @event.save!
      redirect_to event_path(@event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.expect(event_launch: %i[name match_format number_of_coats number_of_players])
  end
end
