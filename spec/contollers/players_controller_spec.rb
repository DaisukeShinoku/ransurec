require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  describe '#show_player_name_dialog' do
    let(:event) { create(:event) } # FactoryBotなどでイベントのインスタンスを作成
    let(:player) { create(:player, event: event) } # イベントに紐づくプレイヤーを作成

    context 'パラメータにevent_idのみがある場合' do
      it '指定されたイベントを@eventに割り当てること' do
        get :show_player_name_dialog, params: { event_id: event.id }, format: :turbo_stream
        expect(assigns(:event)).to eq(event)
      end

      it '@statusに"block"を割り当てること' do
        get :show_player_name_dialog, params: { event_id: event.id }, format: :turbo_stream
        expect(assigns(:status)).to eq("block")
      end

      it 'turbo_stream形式でレスポンスを返すこと' do
        get :show_player_name_dialog, params: { event_id: event.id }, format: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end

      it '"name_edit_dialog"のturbo_stream.replaceアクションを含むこと' do
        get :show_player_name_dialog, params: { event_id: event.id }, format: :turbo_stream
        expect(response.body).to include('<turbo-stream action="replace" target="name_edit_dialog">')
      end

      it '"players/name_edit_dialog"パーシャルをレンダリングすること' do
        get :show_player_name_dialog, params: { event_id: event.id }, format: :turbo_stream
        expect(response).to render_template(partial: 'players/_name_edit_dialog')
      end

      it 'レンダリングされたパーシャルに@eventと@statusローカル変数を渡すこと' do
        get :show_player_name_dialog, params: { event_id: event.id }, format: :turbo_stream
        expect(response).to render_template(locals: { event: event, status: "block" })
      end
    end

    context 'パラメータにevent_idとstatusがある場合' do
      it '@statusにパラメータのstatusの値を割り当てること' do
        get :show_player_name_dialog, params: { event_id: event.id, status: "none" }, format: :turbo_stream
        expect(assigns(:status)).to eq("none")
      end

      it 'レンダリングされたパーシャルにパラメータのstatusの値を渡すこと' do
        get :show_player_name_dialog, params: { event_id: event.id, status: "none" }, format: :turbo_stream
        expect(response).to render_template(locals: { event: event, status: "none" })
      end
    end

    context '無効なevent_idが渡された場合' do
      it 'ActiveRecord::RecordNotFoundエラーが発生すること' do
        expect {
          get :show_player_name_dialog, params: { event_id: 999 }, format: :turbo_stream
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
