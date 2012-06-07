require 'api_constraints'

UKTradeTariff::Application.routes.draw do
  namespace :api, defaults: {format: 'json'}, path: "/" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ }
      resources :chapters, only: [:show], constraints: { id: /\d{2}/ }
      resources :headings, only: [:show], constraints: { id: /\d{4}/ } do
        member do
          get :import_measures
          get :export_measures
        end
      end
      resources :commodities, only: [:show, :update], constraints: { id: /\d{12}/ } do
        member do
          get :import_measures
          get :export_measures
        end
      end

      post "search" => "search#search", via: :post, as: :search
    end
  end

  root to: 'home#show'
end
