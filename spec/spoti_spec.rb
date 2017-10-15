
require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/spotify_api.rb'

describe 'Tests Spotify library' do
  TRACK_ID = '6b8Be6ljOzmkOmFslEb23P'.freeze
  ALBUM_ID = '4PgleR09JVnm3zY1fW3XBA'.freeze
  ARTIST_ID = '0du5cEVh5yTK9QJze8zA0C'.freeze
  CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
  CLIENT_ID = CONFIG['client_id']
  CLIENT_SECRET = CONFIG['client_secret']
  CORRECT = YAML.load(File.read('spec/fixtures/sp_results.yml'))
  RESPONSE = YAML.load(File.read('spec/fixtures/sp_response.yml'))

  describe 'Track information' do
    it 'HAPPY: should provide correct track attributes' do
      track = SpotifyModule::SpotifyAPI.new(CLIENT_ID,CLIENT_SECRET, cache: RESPONSE)
                                  .track(TRACK_ID)
      _(track.name).must_equal CORRECT[TRACK_ID]['name']
      _(track.duration_ms).must_equal CORRECT[TRACK_ID]['duration_ms']
      _(track.id).must_equal CORRECT[TRACK_ID]['id']
      _(track.artists).must_equal CORRECT[TRACK_ID]['artists']
      _(track.album).must_equal CORRECT[TRACK_ID]['album']
      _(track.track_url).must_equal CORRECT[TRACK_ID]['track_url']
    end

    it 'SAD: should raise exception on incorrect track' do
      proc do
        SpotifyModule::SpotifyAPI.new(CLIENT_ID,CLIENT_SECRET, cache: RESPONSE).track('foo')
      end.must_raise SpotifyModule::SpotifyAPI::Errors::InvalidId
    end
  end

  describe 'Album information' do
    it 'HAPPY: should provide correct album attributes' do
      album = SpotifyModule::SpotifyAPI.new(CLIENT_ID,CLIENT_SECRET, cache: RESPONSE)
                                  .album(ALBUM_ID)
      _(album.name).must_equal CORRECT[ALBUM_ID]['name']
      _(album.genres).must_equal CORRECT[ALBUM_ID]['genres']
      _(album.id).must_equal CORRECT[ALBUM_ID]['id']
      _(album.artists).must_equal CORRECT[ALBUM_ID]['artists']
      _(album.images).must_equal CORRECT[ALBUM_ID]['images']
      _(album.tracks).must_equal CORRECT[ALBUM_ID]['tracks']
      _(album.album_url).must_equal CORRECT[ALBUM_ID]['album_url']
      _(album.total_tracks).must_equal CORRECT[ALBUM_ID]['total_tracks']
    end

    it 'SAD: should raise exception on incorrect album' do
      proc do
        SpotifyModule::SpotifyAPI.new(CLIENT_ID,CLIENT_SECRET, cache: RESPONSE).album('foo')
      end.must_raise SpotifyModule::SpotifyAPI::Errors::InvalidId
    end
  end

  describe 'Artist information' do
    it 'HAPPY: should provide correct artist attributes' do
      artist = SpotifyModule::SpotifyAPI.new(CLIENT_ID,CLIENT_SECRET, cache: RESPONSE)
                                  .artist(ARTIST_ID)                     
      _(artist.name).must_equal CORRECT[ARTIST_ID]['name']
      _(artist.genres).must_equal CORRECT[ARTIST_ID]['genres']
      _(artist.id).must_equal CORRECT[ARTIST_ID]['id']
      _(artist.images).must_equal CORRECT[ARTIST_ID]['images']
      _(artist.artist_url).must_equal CORRECT[ARTIST_ID]['artist_url']
    end

    it 'SAD: should raise exception on incorrect artist' do
      proc do
        SpotifyModule::SpotifyAPI.new(CLIENT_ID,CLIENT_SECRET, cache: RESPONSE).artist('foo')
      end.must_raise SpotifyModule::SpotifyAPI::Errors::InvalidId
    end
  end
end
