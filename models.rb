require 'bundler/setup'
Bundler.require

if development?
    ActiveRecord::Base.establish_connection
end