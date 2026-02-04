Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"

      resources :patients
      resources :claims do
        collection do
          get :export
        end
      end
      resources :claim_imports, only: [:create, :index, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
