Rails.application.routes.draw do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'auth/registrations', omniauth_callbacks: 'users/omniauth_callbacks'
    }
    resources :users, only: [:index, :show] do
        get :whoami, on: :collection
        resource :rooms, only: [:create, :destroy]
        resource :relationships, only: [:create, :destroy]
    end
    resources :relationships, only: [:index]
    resources :rooms, only: [:index, :show] do
        resource :messages, only: [:create, :destroy]
    end
    resources :recipes do
        resource :comments, only: [:create, :destroy]
        resources :favorites, only: [:index, :create, :destroy]
    end
    resources :ingredients
    resources :notifications, only: :index
    resources :groups do
        post :add_user, action: :add_user_group, on: :new
        member do
            get 'owner'
            get 'mygroup'
            post 'remove_user'
        end
    end
end
