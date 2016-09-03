Rails.application.routes.draw do
  resources :analyses, only: [:show]
  resources :analysis_steps
  get "/geo_locations/states_for/:country", to: "geo_locations#states_for"
  root "home#index"
end
