require 'rubygems'
require 'sinatra'
require 'haml'
require 'coffee-script'
require 'mongoid'
require "sinatra-authentication"

use Rack::Session::Cookie, :secret => 'bippity boppity boo, 1 533 whyohyou'

Mongoid.configure do |config|
  if ENV['MONGOLAB_URI']
    conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
    uri = URI.parse(ENV['MONGOLAB_URI'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('test')
  end
end

get '/' do
  haml :index
end

get '/application.js' do
  coffee :application
end