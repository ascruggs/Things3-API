Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      root to: "root#index"

      resources :lists, only: [ :index ], param: :name do
        get :todos, on: :member
      end

      resources :todos, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          post :move
          post :schedule
          post :complete
          post :cancel
          post :show_in_ui, path: "show"
          post :edit
        end
      end

      resources :projects, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          get :todos
          post :complete
          post :show_in_ui, path: "show"
        end
      end

      resources :areas, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          get :todos
          get :projects
          post :show_in_ui, path: "show"
        end
      end

      resources :tags, only: [ :index, :create, :destroy ], param: :name

      get "selected", to: "selected#index"

      post "empty_trash",   to: "actions#empty_trash"
      post "log_completed", to: "actions#log_completed"
      post "quick_entry",   to: "actions#quick_entry"
    end

    namespace :v2 do
      root to: "root#index"

      resources :todos, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          post :move
          post :schedule
          post :complete
          post :cancel
          post :show_in_ui, path: "show"
          post :edit
        end
      end

      resources :projects, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          get :todos
          post :complete
          post :show_in_ui, path: "show"
        end
      end

      resources :areas, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          get :todos
          get :projects
          post :show_in_ui, path: "show"
        end
      end

      resources :tags, only: [ :index, :create, :destroy ], param: :name

      resources :lists, only: [ :index ], param: :name do
        get :todos, on: :member
      end

      get "selected", to: "selected#index"

      post "empty_trash",   to: "actions#empty_trash"
      post "log_completed", to: "actions#log_completed"
      post "quick_entry",   to: "actions#quick_entry"

      get  "search",  to: "navigation#search"
      post "json",    to: "utility#json_import"
      get  "version", to: "utility#version"
    end
  end
end
