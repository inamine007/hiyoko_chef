Rails.application.routes.draw do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'auth/registrations', omniauth_callbacks: 'users/omniauth_callbacks'
    }
  
    resources :recipes do
        resources :comments, only: [:create, :destroy]
    end
    resources :ingredients
    resources :groups
end
