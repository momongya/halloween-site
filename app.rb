require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'

get '/' do
    
  erb :index
end

post '/zibu' do
    @zibu = "zibu"
#   debug.log("test OK")
end

get '/api/game' do
    uri = URI("http://express.heartrails.com/api/json")
    uri.query = URI.encode_www_form({
        name: params[:name]
    })
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    if json["response"]["error"]
        response ={ error: "No." }
    else
        response = {
            next: json["response"]
        }
    end
    json response
end