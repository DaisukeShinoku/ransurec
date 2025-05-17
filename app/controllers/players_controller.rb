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
            partial: "events/event_matches_list", # パーシャルをplayersディレクトリに移動
            locals: { event: @event, status: @status } # 必要な変数を渡す
          ),
          turbo_stream.replace(
            "name_edit_dialog", # ダイアログのIDを変更
            partial: "players/name_edit_dialog", # パーシャルをplayersディレクトリに移動
            locals: { event: @event, status: @status } # 必要な変数を渡す
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
    @event = Event.find(params[:event_id]) # event_idを受け取るように変更

    # displayを切り替える
    @status = "block"
    if params[:status]
      # statusがある場合はその値を利用する
      @status = params[:status]
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "name_edit_dialog", # ダイアログのIDを変更
            partial: "players/name_edit_dialog", # パーシャルをplayersディレクトリに移動
            locals: { event: @event, status: @status } # 必要な変数を渡す
          )
        ]
      end
    end
  end
end
