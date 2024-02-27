require 'sidekiq/web'

Rails.application.routes.draw do
  root 'subscriptions#index'
  
  post 'stripe/webhooks', to: 'stripe/webhooks#receive'
  # stripe listen --forward-to localhost:3000/stripe/webhooks

  resources :subscriptions, only: [:index] # to show the processed subscriptions on a simple page

  
  mount Sidekiq::Web => '/sidekiq'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
