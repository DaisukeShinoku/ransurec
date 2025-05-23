class PlayersController < ApplicationController
  def update_all
    @event = Event.find(params[:event_id])
    @status = "none"
    player_params = params[:players]

    ActiveRecord::Base.transaction do
      player_params.each do |id, attributes|
        player = @event.players.find(id)
        player.update!(display_name: attributes[:display_name])
      end
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "matches_list",
            partial: "events/event_matches_list",
            locals: { event: @event, status: @status }
          ),
          turbo_stream.replace(
            "name_edit_dialog",
            partial: "players/name_edit_dialog",
            locals: { event: @event, status: @status }
          )
        ]
      end
    end
  rescue StandardError
    respond_to do |format|
      format.html { redirect_to event_path(@event), alert: I18n.t("player.alerts.update_failed") }
      format.json do
        render json: {
          status: "error",
          alert: I18n.t("player.alerts.update_failed")
        }, status: :unprocessable_entity
      end
    end
  end

  def show_player_name_dialog
    @event = Event.find(params[:event_id])

  
    @status = "block"
    if params[:status]
    
      @status = params[:status]
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "name_edit_dialog",
            partial: "players/name_edit_dialog",
            locals: { event: @event, status: @status }
          )
        ]
      end
    end
  end
end
