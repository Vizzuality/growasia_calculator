Rails.application.routes.draw do
  resources :analyses
  get "/geo_locations/states_for/:country", to: "geo_locations#states_for"
  root "home#index"
end
