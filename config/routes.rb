Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :analyses, only: [:show, :update]
    end
  end
  resources :analyses, only: [:show, :new, :create] do
    member do
      patch 'print'
    end
  end

  get "/geo_locations/states_for/:country", to: "geo_locations#states_for"
  root "home#index"
end
