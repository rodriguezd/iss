class PagesController < ApplicationController
  require 'open-uri'
  require 'geocoder'

  def home
    twitter_feed = TwitterClient.client
    # twitter_feed = TwitterClient
    latest_crew_tweet = twitter_feed.list_timeline(210694515).first
    latest_crew_tweet_id = latest_crew_tweet.id
    @latest_crew_tweet_image = latest_crew_tweet.user.screen_name.downcase + ".jpg"
    json = open("https://api.twitter.com/1/statuses/oembed.json?id=#{latest_crew_tweet_id}").read
    data = JSON.parse(json)
    @crew_tweet_html = data["html"]

    latest_iss_tweet_id = twitter_feed.user_timeline("ISS101").first.id
    json = open("https://api.twitter.com/1/statuses/oembed.json?id=#{latest_crew_tweet_id}").read
    data = JSON.parse(json)
    @iss_tweet_html = data["html"]
  end

  def sightings
    results = Geocoder.search(params[:location])
    latitude = results.first.latitude
    longitude = results.first.longitude

    json = open("http://api.open-notify.org/iss-pass.json?lat=#{latitude}&lon=#{longitude}&n=8").read
    data = JSON.parse(json)

    @sightings = data["response"]
  end

end
