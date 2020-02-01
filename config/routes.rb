Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/404', to: "errors#not_found", as: "err_not_found"
  get '/500', to: "errors#internal_error", as: "err_internal"
  
  get "/healthcheck", to: "application#healthcheck"
  get "/login", to: "application#login", as: "login"
  post "/login", to: "application#login"
  get "/logout", to: "application#logout", as: "logout"

  resources :pet, :event
  resources :user, only: [:new, :create]

  get "/", to: "user#dashboard", as: "dashboard" 
  get "/user/edit", to: "user#edit"
  put "/user", to: "user#update"
  get  "/user", to:  redirect("/user/new")

  get "/pet/:id/events", to: "pet#events", as: "pet_events"
end
