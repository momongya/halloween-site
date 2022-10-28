require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'open-uri'
require 'openssl'
require 'json'
require 'net/http'
require 'dotenv/load'
require 'sinatra/activerecord'
require './models'
require 'date'

before do
    API_ENDPOINT = 'https://mbaas.api.nifcloud.com/2013-09-01/'
    API_KEY = '395bd5a75a13b7a0ed0cef49f6f37a7174f1e482910ee7deeb47a5d20e45ac48'
    CLIENT_KEY = "44626a7762b93256f5d4c2515c1bddfcf0e9441c8e37c112a213268fb2141a0b"
    @halloween_api = Faraday.new(:url => API_ENDPOINT)
    @halloween_api.headers['X-NCMB-Application-Key'] = API_KEY
    @halloween_api.headers['Content-Type'] = 'application/json'
    @halloween_api.headers['Accept-Language'] = 'ja'
end

get '/' do

    # timestamp = Time.now.utc.iso8601
    # テスト
    # secret = "1343d198b510a0315db1c03f3aa0e32418b7a743f8e4b47cbff670601345cf75"
    # messageStr = "GET\nmbaas.api.nifcloud.com\n/2013-09-01/classes/TestClass\nSignatureMethod=HmacSHA256&SignatureVersion=2&X-NCMB-Application-Key=6145f91061916580c742f806bab67649d10f45920246ff459404c46f00ff3e56&X-NCMB-Timestamp=2013-12-02T02:44:35.452Z&where=%7B%22testKey%22%3A%22testValue%22%7D"
    # token = Base64.encode64(OpenSSL::HMAC::digest(OpenSSL::Digest::Digest.new('sha256'), secret, messageStr)).strip()
    # puts token

    #本番
    # timestamp = Time.now.utc.iso8601
    # secret = "395bd5a75a13b7a0ed0cef49f6f37a7174f1e482910ee7deeb47a5d20e45ac48"
    # messageStr = "GET\nmbaas.api.nifcloud.com\n/2013-09-01/classes/HighScore\nSignatureMethod=HmacSHA256&SignatureVersion=2&X-NCMB-Application-Key=#{API_KEY}&X-NCMB-Timestamp=#{timestamp}"
    # token = Base64.encode64(OpenSSL::HMAC::digest(OpenSSL::Digest::Digest.new('sha256'), secret, messageStr)).strip()
    timestamp = Time.now.iso8601
    messageStr = "GET\nmbaas.api.nifcloud.com\n/2013-09-01/classes/HighScore\nSignatureMethod=HmacSHA256&SignatureVersion=2&X-NCMB-Application-Key=#{API_KEY}&X-NCMB-Timestamp=#{timestamp}"
    signature = Base64.encode64(OpenSSL::HMAC::digest(OpenSSL::Digest::Digest.new('sha256'), CLIENT_KEY, messageStr)).strip()
    @halloween_api.headers['X-NCMB-Signature'] = signature
    @halloween_api.headers['X-NCMB-Timestamp'] = timestamp
    
    res = @halloween_api.get 'classes/HighScore'

    data = JSON.parse(res.body)
    result = data["results"].map { |member| 
        {
            name: member["Name"],
            team: member["Team"],
            score: member["Score"],
        }
    }
    
    @ranking_data = [
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
        {:name=>"Geek", :team=>"Geek", :score=>270},
    ]
    
    # @ranking_data = result.sort do |min, max|
    #     max[:score] <=> min[:score]
    # end
    
    total_score = 0
    @ranking_data.each{|data|
      total_score += data[:score]
    }
    @total_score = total_score
    
    @target_score = 0000
    
    erb :index
end