require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
require 'open-uri'
require 'json'
require 'net/http'

# get '/' do
    
#   erb :index
# end

post '/zibu' do
    @zibu = "zibu"
end

get '/' do
    uri = URI("https://mbaas.api.nifcloud.com/2013-09-01/classes/HighScore")
    uri.query = URI.encode_www_form({
        Name: "t"
    })
    res = Net::HTTP.get_response(uri)
    returned_json = JSON.parse(res.body)
    puts "#{returned_json}"
    @zibu = returned_json["results"]
    erb :index
end