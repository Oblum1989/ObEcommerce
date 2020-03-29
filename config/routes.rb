Rails.application.routes.draw do
  get '/health', to: 'health#health'
  resources :comments
  resources :posts
end
