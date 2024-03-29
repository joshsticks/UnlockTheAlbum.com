$: << File.dirname(__FILE__) + "/models"
require 'rubygems'
require 'sinatra'
require 'haml'
require 'coffee-script'
require 'mongoid'
require "sinatra-authentication"
require 'blog'
  
#if you change things to do with the app and it's running then it won't be in effect, dur
set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/"

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

get '/blog' do
  @posts = Post.all
  haml :blog
end

post '/blog' do
  login_required
  redirect "/blog" unless current_user.email == 'sticklesjb@gmail.com'
  @post = Post.create!(params[:post])
end