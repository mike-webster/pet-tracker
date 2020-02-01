Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :pet, :event
  resources :user, only: [:new, :create]
  get "/", to: "user#dashboard", as: "dashboard"
  get "/crash", to: "application#crash"
  get "/exception", to: "application#except"
  get "/user/edit", to: "user#edit"
  put "/user", to: "user#update"
  get  "/user", to:  redirect("/user/new")

  get "/healthcheck", to: "application#healthcheck"
  get "/pet/:id/events", to: "pet#events", as: "pet_events"
  get "/login", to: "application#login", as: "login"
  post "/login", to: "application#login"
  get "/logout", to: "application#logout", as: "logout"
end
