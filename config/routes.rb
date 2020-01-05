Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :pet, :event, :user

  get "/healthcheck", to: "application#healthcheck"
  get "/pet/:id/events", to: "pet#events"
end
