class MatchesController < ApplicationController
  def update
    @match = Match.find(params[:id])

    if @match.update(match_params)
      @status = "none"
      flash[:notice] = I18n.t("match.notices.updated")
      respond_to do |format|
        format.html { redirect_to event_path(@match.event), notice: flash[:notice] }
        format.json { render json: { status: :ok, match: @match, notice: flash[:notice] } }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "dialog_match_id_#{@match.id}",
              partial: "matches/score_dialog",
              locals: { match: @match, status: @status }
            ),
            turbo_stream.replace(
              "match_id_#{@match.id}",
              partial: "matches/match_detail",
              locals: { match: @match }
            ),
            turbo_stream.replace(
              "flash-messages",
              partial: "shared/flash_messages"
            )
          ]
        end
      end
    else
      flash[:alert] = I18n.t("match.alerts.update_failed")
      respond_to do |format|
        format.html { redirect_to event_path(@match.event), alert: flash[:alert] }
        format.json do
          render json: { status: :unprocessable_entity, errors: @match.errors.full_messages,
                         alert: flash[:alert] }, status: :unprocessable_entity
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "dialog_match_id_#{@match.id}",
              partial: "matches/score_dialog",
              locals: { match: @match, status: "block" }
            ),
            turbo_stream.replace(
              "flash-messages",
              partial: "shared/flash_messages"
            )
          ]
        end
      end
    end
  end

  def show_score_dialog
    @match = Match.find(params[:id])
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
            "dialog_match_id_#{@match.id}",
            partial: "matches/score_dialog",
            locals: { match: @match, status: @status }
          ),
          turbo_stream.replace(
            "match_id_#{@match.id}",
            partial: "matches/match_detail",
            locals: { match: @match }
          )
        ]
      end
    end
  end

  def rotate
    @match = Match.find(params[:id])
    @match.rotate_match_players

    respond_to do |format|
      format.html { redirect_to event_path(@match.event), notice: I18n.t("match.notices.rotated") }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "match_id_#{@match.id}",
            partial: "matches/match_detail",
            locals: { match: @match }
          )
        ]
      end
    end
  end

  private

  def match_params
    params.expect(match: %i[home_score away_score])
  end
end
