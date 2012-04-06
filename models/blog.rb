require 'rubygems'
require 'sinatra'

class Post
  include Mongoid::Document
  Page = "page"
  Post = "post"

  has_and_belongs_to_many :tags
  embeds_many :comments

  def date
    created.strftime "%B %d, %Y"
  end

  def summary(length=300)
    body.gsub(/(<[^>]*>)|\n|\t/s," ")[0..length]
  end

  def update_title(value)

    raise "[ ! ] Could not find title for post" if value.nil?

    self.title = value
    self.name = value.downcase.gsub(/[^\w]/,"_").gsub(/__/,"")
  end
end

class Tag
  include Mongoid::Document
  has_and_belongs_to_many :posts, :order => :created.desc
end

class Comment
  include Mongoid::Document
  embedded_in :posts

  def post
    Post[:id => post_id]
  end
end
