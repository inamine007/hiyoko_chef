Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2,ENV['GOOGLE_KEY'],ENV['GOOGLE_SECRET'], name: :google, scope: %w(email)
  end