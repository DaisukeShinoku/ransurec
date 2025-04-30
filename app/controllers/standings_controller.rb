class StandingsController < ApplicationController
  def show
    @event = Event.find(params[:event_id])
    @standings = @event.player_standings
  end
end
