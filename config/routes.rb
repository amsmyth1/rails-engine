Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/v1/revenue/merchants/:merchant_id', to: 'api/v1/revenue#merchant_revenue'
  get '/api/v1/revenue/merchants', to: 'api/v1/revenue#top_merchants'
  get '/api/v1/revenue/unshipped', to: 'api/v1/revenue#unshipped'
  get '/api/v1/items/find_all', to: 'api/v1/searches#find_all_items'
  get '/api/v1/merchants/find', to: 'api/v1/searches#find_one_merchant'
  
  namespace :api do
    namespace :v1 do
      resources :items do
        resources :merchant, only: :index, controller: 'items/merchant'
      end
      resources :merchants do
        resources :items, only: :index, controller: 'merchants/items'
      end
    end
  end

end
