Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check


  # Ths spelling of these route absolutely needs to match the controller file name
  # If it's misspelled or accidentally pluralized, swagger_generate will not detect it
  resources :states, only: [:index, :show, :update]
  resources :discipline, only: [:index]
end
