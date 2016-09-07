Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :analyses, only: [:show]
    end
  end
  resources :analyses, only: [:show, :new, :create]

  get "/geo_locations/states_for/:country", to: "geo_locations#states_for"
  root "home#index"
end
