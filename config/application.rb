require_relative "boot"

require "rails/all"
require 'dotenv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpotifyFavoriteArtistFollower
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # RSpotify authentication
    Dotenv.load('config/.env')
    client_id = ENV["CLIENT_ID"]
    client_secret = ENV["CLIENT_SECRET"]
    RSpotify::authenticate(client_id, client_secret)

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
