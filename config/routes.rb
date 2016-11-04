Rails.application.routes.draw do
  root 'home#index'
  get 'start_bot' => 'home#start_bot'
  get 'get_to_api' => 'home#get_to_api'
  get 'set_webhook' => 'home#set_webhook'
  match 'webhook_request' => 'home#webhook_request', via: [:get, :post], as: :webhook_request


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
