Rails.application.routes.draw do
  resources :searches
  resources :listings
  resources :users
  get 'home/index'
  root 'home#index'
  get 'home/route'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
