class PagesController < ApplicationController
  require 'open-uri'
  require 'geocoder'

  # class TwitterFeed

  #   def client
  #     @client ||= TwitterClient.client
  #   end

  #   def latest_crew_tweet
  #     @latest_crew_tweet ||= client.list_timeline(210694515).first
  #   end

  #   def crew_tweet_image
  #     latest_crew_tweet.user.screen_name.downcase + ".jpg"
  #   rescue Twitter::Error => e
  #     ''
  #   end

  #   def crew_html
  #     @crew_html ||= fetch_crew_html
  #   end

  #   private

  #   def fetch_crew_html
  #     latest_crew_tweet_id = latest_crew_tweet.id
  #     json = open("https://api.twitter.com/1/statuses/oembed.json?id=#{latest_crew_tweet_id}").read
  #     data = JSON.parse(json)
  #     data["html"]
  #   rescue Twitter::Error => e
  #     ''
  #   end
  # end

  def home
    twitter_feed = TwitterClient.client
    latest_crew_tweet = twitter_feed.list_timeline(210694515).first
    latest_crew_tweet_id = latest_crew_tweet.id
    @latest_crew_tweet_image = latest_crew_tweet.user.screen_name.downcase + ".jpg"
    json = open("https://api.twitter.com/1/statuses/oembed.json?id=#{latest_crew_tweet_id}").read
    data = JSON.parse(json)
    @crew_tweet_html = data["html"]

    latest_iss_tweet_id = twitter_feed.list_timeline(212963954).first.id
    json = open("https://api.twitter.com/1/statuses/oembed.json?id=#{latest_iss_tweet_id}").read
    data = JSON.parse(json)
    @iss_tweet_html = data["html"]
  end

  def sightings
    results = Geocoder.search(params[:location])
    latitude = results.first.latitude
    longitude = results.first.longitude

    json = open("http://api.open-notify.org/iss-pass.json?lat=#{latitude}&lon=#{longitude}&n=30").read
    data = JSON.parse(json)

    sightings = data["response"].map do |sighting|
      if Time.at(sighting["risetime"]).hour > 18 || Time.at(sighting["risetime"]).hour < 7
        [Time.at(sighting["risetime"]).strftime("%B %-d at %-I:%M %p"),
        (sighting["duration"] / 60).to_s + " min " + (sighting["duration"]%60).to_s + " sec"]
      end
    end
    @sightings = sightings.compact
  end

end
