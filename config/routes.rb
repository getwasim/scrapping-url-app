Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :pages, only: [:index] do
        post :save_url_data, on: :collection
      end
    end
  end
end