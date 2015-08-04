Rails.application.routes.draw do
  root "searches#index"

  resources :searches
end
