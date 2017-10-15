require_relative 'album.rb'
require_relative 'track.rb'

module SpotifyModule
  # Model for Artist
  class Artist
    def initialize(artist_data)
      @artist = artist_data
    end

    def name
      @artist['name']
    end

    def genres
      @artist['genres']
    end

    def id
      @artist['id']
    end

    def images
      @artist['images']
    end

    def artist_url
      @artist['external_urls']['spotify']
    end
  end
end
