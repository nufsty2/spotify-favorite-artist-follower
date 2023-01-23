class UsersController < ApplicationController
  BATCH_SIZE = 50

  def spotify
    my_user = RSpotify::User.new(request.env['omniauth.auth'])

    fav_artists = get_artists_from_liked_songs(my_user)
    follow_artists_batch(my_user, fav_artists)

    puts "Done!"
  end

  # Gets all of the user's favorite artists based on their liked songs.
  #
  # @param {RSpotify::User} user: the user whose favorite artists we want
  # @return {RSpotify::Artist[]} artists: all of the user's favorite artists
  def get_artists_from_liked_songs(user)
    offset = 0
    artists = Hash.new

    while true
      fav_tracks_batch = user.saved_tracks(limit: BATCH_SIZE, offset:)

      break if fav_tracks_batch.empty?

      fav_tracks_batch.each do |track|
        track.artists.each { |artist| artists[artist.id] = artist if artists[artist.id].nil? }
      end

      offset += BATCH_SIZE
    end

    artists.values
  end

  # Makes the user follow each of the artists in batches of BATCH_SIZE.
  #
  # @param {RSpotify::User} user: the user we are modifying
  # @param {RSpotify::Artist[]} artists: the artists we want to follow
  def follow_artists_batch(user, artists)
    follow_count = 0
    artists_to_follow = []

    artists.each do |artist|
      if artists_to_follow.size == BATCH_SIZE or follow_count == artists.size
        user.follow(artists_to_follow)
        artists_to_follow = []
      else
        artists_to_follow.push(artist)
        follow_count += 1
      end
    end
  end
end
