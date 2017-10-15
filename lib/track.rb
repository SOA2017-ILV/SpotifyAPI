require_relative 'artist.rb'
require_relative 'album.rb'

module SpotifyModule
    #Model for Track
    class Track
        def initialize(track_data)
            @track = track_data
        end

        def name
            @track['name']
        end

        def duration_ms
            @track['duration_ms']
        end

        def id
            @track['id']
        end

        def artists
            @track['artists'].map { |artist| {name: artist['name'], id: artist['id'], artist_url: artist['external_urls']['spotify']}}
        end
        
        def album
            {name: @track['album']['name'], id: @track['album']['id'], album_url: @track['album']['external_urls']['spotify'], image_url: @track['album']['images']}
        end
        
        def track_url
            @track['external_urls']['spotify']
        end
    end
end