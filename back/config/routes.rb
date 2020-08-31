Rails.application.routes.draw do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'auth/registrations', omniauth_callbacks: 'users/omniauth_callbacks'
    }
  
    resources :recipes do
        resources :comments, only: [:create, :destroy]
    end
    resources :ingredients
    resources :groups do
        post :add_user, action: :add_user_group, on: :new
        member do
            get 'owner'
            get 'mygroup'
            post 'remove_user'
        end
    end
end
