require 'net/http'
require 'uri'
require 'net/https'
require 'json'
require 'yaml'
require 'base64'

config = YAML.safe_load(File.read('config/secrets.yml'))
API_URI = 'https://api.github.com/v1/'.freeze
TOKEN_URI = 'https://accounts.spotify.com/api/token'.freeze


def sp_api_path(path)
	API_URI + path
end

def call_sp_url(config,url)
	grant_type = 'client_credentials'
	client_id_and_secret = Base64.strict_encode64("#{config['client_id']}:#{config['client_secret']}")
	HTTP.headers(
		'Accept' => '',
		'Authorization' => 'token #{@token_id }'
	).post(url, params: {'grant_type' => grant_type})
end

def get_auth_token(config)
	uri = URI(TOKEN_URI)
	https = Net::HTTP.new(uri.host, uri.port)
	https.use_ssl = true
	req = Net::HTTP::Post.new(uri.path, initheader = auth_header(config))
	request_body = URI.encode_www_form({grant_type: 'client_credentials'})
	req.body = request_body
	res = https.request(req)
	return res["access_token"]
end

def auth_header(config)
	authorization = Base64.strict_encode64("#{config['client_id']}:#{config['client_secret']}")
	{ 'Authorization' => "Basic #{authorization}" }
end

sp_response = {}
sp_results = {}
token = get_auth_token(config)

#auth(config)
