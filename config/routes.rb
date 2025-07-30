Rails.application.routes.draw do

  resources :tb_policies, path: "/app/v1/tb_policies"

  resources :tb_customers, path: "/app/v1/tb_customers"

  post '/app/token', to: 'app#token'

  get "up" => "rails/health#show", as: :rails_health_check


end
