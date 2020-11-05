Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    sessions: "sessions",
    registrations: "registrations",
    omniauth_callbacks: "omniauth_callbacks"
  }
  
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:index] do 
      put 'avatar', to: 'user_records#update_avatar'
    end
    get 'users/auth/facebook', to: 'users#facebook'
    get '/users/verify', to: 'users#verify'
    get 'users/leaderboard', to: 'user_records#leaderboard'
    get 'users/my_stats', to: 'user_records#my_stats'
    resources :games, only: [:create]
    get 'games/now', to: 'games#now'
    get 'game/invites', to: 'games#invites'
    resources :products, only: [:index]
  end
  
  mount ActionCable.server => "/cable"

  root 'ludo#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/*path', to: 'ludo#index'
end
