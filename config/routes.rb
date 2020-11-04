Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    sessions: "sessions",
    registrations: "registrations",
    omniauth_callbacks: "omniauth_callbacks"
  }
  
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:index] do 
      put 'avatar', to: 'users#update_avatar'
    end
    get 'users/auth/facebook', to: 'users#facebook'
    get '/users/verify', to: 'users#verify'
    resources :invites, only: [:index]
    get 'invites/today', to: 'invites#now'
    resources :games, only: [:create]
    resources :products, only: [:index]
  end
  
  mount ActionCable.server => "/cable"

  root 'ludo#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/*path', to: 'ludo#index'
end
