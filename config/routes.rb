Rails.application.routes.draw do
  namespace :api do
    devise_for :users,
      path: "auth",
      path_names: {
        sign_in:  "sign_in",
        sign_out: "sign_out",
        registration: "sign_up"
      },
      controllers: {
        sessions:      "api/auth/sessions",
        registrations: "api/auth/registrations"
      }

    resources :articles, only: %i[index show create update destroy] do
      resources :comments, only: %i[index create]
    end

    resources :sections, only: %i[index show]
    resources :tags, only: %i[index]
    resources :bookmarks, only: %i[index create destroy]

    namespace :reports do
      get :popular
    end

    resource :profile, only: %i[show update]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
