Rails.application.routes.draw do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'auth/registrations', omniauth_callbacks: 'users/omniauth_callbacks'
    }
  
    resources :recipes
    resources :ingredients
    resources :groups
end
