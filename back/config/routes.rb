Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations', omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: [:index, :show] do
    get :whoami, on: :collection
    resource :relationships, only: [:create, :destroy]
    member do
      get 'followings'
      get 'followers'
    end
  end

  resources :relationships, only: :index do
    get :recipes, on: :collection
  end

  resources :rooms do
    resources :messages, only: [:index, :create, :destroy]
  end

  resources :recipes do
    collection do
      get 'confirm'
      get 'search'
    end
    member do
      get 'user'
      get 'comments'
      get 'ingredients'
    end
    resource :comments, only: [:create, :destroy]
    resources :favorites, only: :index do
      get :users, on: :collection
    end
    resource :favorites, only: [:create, :destroy]
  end

  resources :ingredients
  resources :notifications, only: :index do
    collection do
      get 'checked'
      get 'destroy_all'
    end
  end

  resources :categories, only: :index do
    collection do
      get 'my_count'
      get 'search'
    end
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
