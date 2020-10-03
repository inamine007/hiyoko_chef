Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations', omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, only: [:index, :show] do
    get :whoami, on: :collection
    resource :rooms, only: [:create, :destroy]
    resource :relationships, only: [:create, :destroy]
    member do
      get 'followings'
      get 'followers'
    end
  end
  resources :relationships, only: :index
  resources :rooms, only: [:index, :show] do
      resource :messages, only: [:create, :destroy]
  end
  resources :recipes do
    get :confirm, on: :collection
    member do
      get 'user'
      get 'comments'
    end
    resource :comments, only: [:create, :destroy]
    resources :favorites, only: :index do
      get :users, on: :collection
    end
    resource :favorites, only: [:create, :destroy]
  end
  resources :ingredients
  resources :notifications, only: :index
  resources :categories, only: :index do
    get :my_count, on: :collection
    get :user_count, on: :member
  end
  resources :groups do
    post :add_user, action: :add_user_group, on: :new
    member do
      get 'owner'
      get 'mygroup'
      get 'members'
      post 'remove_user'
    end
  end
end
