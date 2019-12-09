Rails.application.routes.draw do
  root 'root#root'
  resources :episodes do
    member do
      post 'transcribe'
    end
  end
  resources :scripts
  resources :podcasts do
    member do
      post 'import'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
