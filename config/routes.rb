Rails.application.routes.draw do
  resources :episodes
  resources :scripts
  resources :podcasts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
