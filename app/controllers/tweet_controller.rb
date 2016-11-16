require 'twitter'

class TweetController < ApplicationController
  def index
    client = TweetController.create_client
    begin
      @friends = client.friends
      @tweets = get_tweets(client)
    rescue => e
      #TODO: render 404 with the error
       puts "Error : #{e.to_s}"
    end
  end


  private
  def get_tweets(client)
    tweets =
      if params.key?("selected_users") && params["selected_users"].is_a?(Array)
        client.search(get_query(params["selected_users"]), :result_type => "recent").collect
      else
        client.home_timeline(count: 100)
      end
  end

  def get_query(selected_users)
    q = ""
    selected_users.each do |x|
      if q.empty?
        q+= "from:#{x}"
      else
        q+= "+OR+from:#{x}"
      end
    end
   q
  end

  def self.create_client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = "YOUR_CONSUMER_KEY"
      config.consumer_secret     = "YOUR_CONSUMER_SECRET"
      config.access_token        = "YOUR_ACCESS_TOKEN"
      config.access_token_secret = "YOUR_ACCESS_SECRET"
    end
  end
end