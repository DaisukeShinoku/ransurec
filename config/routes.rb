Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # FIXME: /.well-known/appspecific/com.chrome.devtools.json へのリクエストに対応するための暫定措置
  # Chrome DevToolsが開発モード時にこのJSONファイルを要求するため、エラーログ抑制のために定義しています。
  # より恒久的な対策や、他の .well-known URI への対応が必要になった場合は、
  # Rackミドルウェアでの処理などを検討してください。
  get "/.well-known/appspecific/com.chrome.devtools.json", to: proc { [204, {}, ["\n"]] }

  # Defines the root path route ("/")
  root "events#new"
  resources :events, only: %i[show new create] do
    resource :standings, only: %i[show]
  end
  resources :matches, only: %i[update] do 
    member do
      get :show_score_dialog
      post :rotate
    end
  end
  resources :players, only: [] do
    collection do
      patch :update_all
      get :show_player_name_dialog
    end
  end
end
