require 'net/http'
require 'uri'
require 'http' 
require 'net/https'
require 'json'
require 'yaml'
require 'base64'

config = YAML.safe_load(File.read('config/secrets.yml'))
API_URI = 'https://api.spotify.com/'.freeze
TOKEN_URI = 'https://accounts.spotify.com/api/token'.freeze

def sp_api_path(path)
  API_URI + path
end

def call_sp_url(access_token,url)
  uri = URI(url)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  req = Net::HTTP::Get.new(uri.path, initheader = {"Authorization" => "Bearer #{access_token}"})
  res = https.request(req)
  JSON.parse(res.body)
end

def get_auth_token(config)
  uri = URI(TOKEN_URI)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  req = Net::HTTP::Post.new(uri.path, initheader = auth_header(config))
  request_body = URI.encode_www_form({grant_type: 'client_credentials'})
  req.body = request_body
  res = https.request(req)
  JSON.parse(res.body)["access_token"]
end

def auth_header(config)
  authorization = Base64.strict_encode64("#{config['client_id']}:#{config['client_secret']}")
  { 'Authorization' => "Basic #{authorization}" }
end

sp_response = {}
sp_results = {}
access_token = get_auth_token(config)

track_url = sp_api_path('v1/tracks/6b8Be6ljOzmkOmFslEb23P')
sp_response[track_url] = call_sp_url(access_token, track_url)
track = sp_response[track_url]
sp_results[track_url] = {}
sp_results[track_url]['name'] = track['name']
sp_results[track_url]['duration_ms'] = track['duration_ms']
sp_results[track_url]['id'] = track['id']
sp_results[track_url]['artists'] = track['artists'].map { |artist| {name: artist['name'], id: artist['id'], artist_url: artist['external_urls']['spotify']}}
sp_results[track_url]['album'] = {name: track['album']['name'], id: track['album']['id'], album_url: track['album']['external_urls']['spotify'], image_url: track['album']['images']}
sp_results[track_url]['track_url'] = track['external_urls']['spotify']

#BAD URL
bad_track_url = sp_api_path('v1/tracks/foo')
sp_response[bad_track_url] = call_sp_url(access_token, bad_track_url)

album_url = sp_api_path('v1/albums/4PgleR09JVnm3zY1fW3XBA')
sp_response[album_url] = call_sp_url(access_token, album_url)
album = sp_response[album_url]

sp_results[album_url] = {}
sp_results[album_url]["name"] = album["name"]
sp_results[album_url]["id"] = album["id"]
sp_results[album_url]["album_url"] = album["external_urls"]["spotify"]
sp_results[album_url]["genres"] = album["genres"]
sp_results[album_url]["images"] = album["images"]
sp_results[album_url]["tracks"] = album["tracks"]["items"].map { |track| {name: track["name"], duration_ms: track["duration_ms"], track_url: track["external_urls"]["spotify"], id: track["id"], track_number: track["track_number"], disc_number: track["disc_number"] }}
sp_results[album_url]["artists"] = album["artists"].map { |artist| {name: artist["name"], id: artist["id"], artist_url: artist["external_urls"]["spotify"]}}
sp_results[album_url]["total_tracks"] = album["tracks"]["total"]

bad_album_url = sp_api_path('v1/albums/foo')
sp_response[bad_album_url] = call_sp_url(access_token, bad_album_url)

artist_url = sp_api_path('v1/artists/0du5cEVh5yTK9QJze8zA0C')
sp_response[artist_url] = call_sp_url(access_token, artist_url)
artist = sp_response[artist_url]

sp_results[artist_url] = {}
sp_results[artist_url]["id"] = artist["id"]
sp_results[artist_url]["name"] = artist["name"]
sp_results[artist_url]["genres"] = artist["genres"]
sp_results[artist_url]["artist_url"] = artist["external_urls"]["spotify"]
sp_results[artist_url]["images"] = artist["images"]


File.write('spec/fixtures/sp_response.yml', sp_response.to_yaml)
File.write('spec/fixtures/sp_results.yml', sp_results.to_yaml)