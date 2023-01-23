require 'rspotify/oauth'

# RSpotify authentication
Dotenv.load('config/.env')
client_id = ENV["CLIENT_ID"]
client_secret = ENV["CLIENT_SECRET"]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, client_id, client_secret, scope: 'user-read-email user-library-read user-library-modify user-follow-read user-follow-modify'
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true