Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :users, only: [ :new, :create ]
  resources :series do
    resources :episodes, shallow: true
    resources :characters, only: [ :new, :create, :show ], shallow: true do
      member do
        post :generate_portrait
      end
    end
    resources :locations, only: [ :new, :create, :edit, :update, :destroy ], shallow: true
    resources :series_producers, only: [ :index, :create, :destroy ], path: "producers"
  end
end
