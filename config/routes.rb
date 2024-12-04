Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api, constraints: { format: :json }, :defaults => { :format => 'json' } do
    namespace :v1 do
      namespace :ai do
        resources :inquiries, only: [:show] do
          member { post "triggers/:type", action: :trigger_on_member }
          collection { post "triggers/:type", action: :trigger_on_collection }
        end

        resources :messages, only: [:show, :update] do
          member { post "triggers/:type", action: :trigger_on_member }
          collection { post "triggers/:type", action: :trigger_on_collection }
        end
      end
    end
  end
end