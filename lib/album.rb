require_relative 'artist.rb'
require_relative 'track.rb'

module SpotifyModule
  # Model for Album
  class Album
    def initialize(album_data)
      @album = album_data
    end

    def name
      @album['name']
    end

    def genres
      @album['genres']
    end

    def id
      @album['id']
    end

    def artists
      @album["artists"].map { |artist| {name: artist["name"], id: artist["id"], artist_url: artist["external_urls"]["spotify"]}}
    end

    def images
      @album['images']
    end

    def tracks
      @album["tracks"]["items"].map { |track| {name: track["name"], duration_ms: track["duration_ms"], track_url: track["external_urls"]["spotify"], id: track["id"], track_number: track["track_number"], disc_number: track["disc_number"] }}
    end

    def total_tracks
      @album['tracks']["total"]
    end

    def album_url
      @album['external_urls']["spotify"]
    end
  end
end
