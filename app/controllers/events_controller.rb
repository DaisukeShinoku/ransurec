class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @players = @event.players
    @status = "none";
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

  def update
    @event = Event.find(params[:id])
    @status = "none";
    # パラメータからplayersの情報を取得
    players_params = params[:event][:players]
    players_params.each do |player_id, player_data|
      # player_idに対応するPlayerレコードを取得
      player = @event.players.find_by(id: player_id)
      # display_nameを更新
      player.update(display_name: player_data[:display_name])
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("event_#{@event.id}", partial: "events/replace_match", locals: { event: @event }),
          turbo_stream.replace("dialogue", partial: "events/replace_form", locals: { event: @event, status: @status }),
      ]
      end
    end
  end

  def display_form
    @event = Event.find(params[:id])
    # displayを切り替える
    @status = "block";
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("dialogue", partial: "events/replace_form", locals: { event: @event, status: @status })
      end
    end
  end

  private

  def event_params
    params.expect(event_launch: %i[name match_format number_of_coats number_of_players])
  end

  def update_params
    params.require(:event).permit(
      players_attributes: [:id, :display_name]
    )
  end

end
