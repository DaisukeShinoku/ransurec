class PlayersController < ApplicationController
  def update_all
    @event = Event.find(params[:event_id])
    player_params = params[:players]

    ActiveRecord::Base.transaction do
      player_params.each do |id, attributes|
        player = @event.players.find(id)
        player.update!(display_name: attributes[:display_name])
      end
    end

    respond_to do |format|
      format.html { redirect_to event_path(@event), notice: I18n.t("player.notices.updated") }
      format.json { render json: { status: "ok", notice: I18n.t("player.notices.updated") } }
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
  end
end
