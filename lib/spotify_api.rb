require 'net/http'
require 'uri'
require 'http' 
require 'net/https'
require 'json'
require 'base64'
require_relative 'artist.rb'
require_relative 'album.rb'
require_relative 'track.rb'

module SpotifyModule
  # Class for Spotify API
  class SpotifyAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
      class InvalidId < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound,
      400 => Errors::InvalidId
    }.freeze

    API_URI = 'https://api.spotify.com/'.freeze
    TOKEN_URI = 'https://accounts.spotify.com/api/token'.freeze

    def initialize(client_id,client_secret, cache: {})
      @access_token = get_auth_token(client_id, client_secret)
      @cache = cache
    end

    def track(id)
      track_req_url = sp_api_path(['v1/tracks',id].join('/'))
      track_data = call_sp_url(track_req_url)
      Track.new(track_data)
    end

    def album(id)
      album_req_url = sp_api_path(['v1/albums',id].join('/'))
      album_data = call_sp_url(album_req_url)
      Album.new(album_data)
    end

    def artist(id)
      artist_req_url = sp_api_path(['v1/artists',id].join('/'))
      artist_data = call_sp_url(artist_req_url)
      Artist.new(artist_data)
    end

    private

    def get_auth_token(client_id, client_secret)
      uri = URI(TOKEN_URI)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, initheader = auth_header(client_id, client_secret))
      request_body = URI.encode_www_form({grant_type: 'client_credentials'})
      req.body = request_body
      res = https.request(req)
      JSON.parse(res.body)['access_token']
    end

    def auth_header(client_id, client_secret)
      authorization = Base64.strict_encode64("#{client_id}:#{client_secret}")
      { 'Authorization' => "Basic #{authorization}" }
    end

    def sp_api_path(path)
      API_URI + path
    end

    def call_sp_url(url) 
      uri = URI(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(uri.path, initheader = {"Authorization" => "Bearer #{@access_token}"})
      res = https.request(req)
      res = JSON.parse(res.body)
      successful?(res) ? res : raise_error(res)
    end

    def successful?(res)
      res["error"]? false : true
    end

    def raise_error(res)
      raise(HTTP_ERROR[res["error"]["status"]])
    end
  end
end
