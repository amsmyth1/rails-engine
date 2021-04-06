Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :items
      resources :merchants do
        resources :items, only: :index, controller: 'merchants/items'
      end
    end
  end

  # get '/api/v1/merchants/:merchant_id/items', to: 'api::v1::merchants::items:#index'
end
