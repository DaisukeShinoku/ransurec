class MatchesController < ApplicationController
  def update
    @match = Match.find(params[:id])

    if @match.update(match_params)
      respond_to do |format|
        format.html { redirect_to event_path(@match.event), notice: I18n.t("match.notices.updated") }
        format.json { render json: { status: :ok, match: @match, notice: I18n.t("match.notices.updated") } }
      end
    else
      respond_to do |format|
        format.html { redirect_to event_path(@match.event), alert: I18n.t("match.alerts.update_failed") }
        format.json do
          render json: { status: :unprocessable_entity, errors: @match.errors.full_messages,
                         alert: I18n.t("match.alerts.update_failed") }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def match_params
    params.expect(match: %i[home_score away_score])
  end
end
