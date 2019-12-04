Rails.application.routes.draw do
  resources :episodes do
  end
  resources :scripts
  resources :podcasts do
    member do
      post 'import'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
