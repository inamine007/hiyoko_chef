Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2,ENV['GOOGLE_KEY'],ENV['GOOGLE_SECRET'],name: :google, scope: %w(email)
    if Rails.env.production?
      OmniAuth.config.full_host = "https://back.hiyoko-chef.com:443"
    end
    # OmniAuth.config.full_host = "http://localhost:8080"
  end