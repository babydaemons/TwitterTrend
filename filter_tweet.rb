#!/usr/bin/env ruby

require "json"
require "time"
require "yaml"
require "rubygems"
require "active_record"

config = YAML.load_file( './database.yml' )
# 環境を切り替える
ActiveRecord::Base.establish_connection(config["db"]["production"])

# テーブルにアクセスするためのクラスを宣言
class Tweet < ActiveRecord::Base
  def self.add(tweet)
    id = tweet["id"]
    text = tweet["text"]
    tweet_at = Time.parse(tweet["created_at"]).getlocal
    screen_name = tweet["user"]["screen_name"]
    profile_image_url = tweet["user"]["profile_image_url"]
    sql = sanitize_sql_array(
          [ "INSERT INTO tweets (id, text, tweet_at, screen_name, profile_image_url) VALUES (?, ?, ?, ?, ?);",
          id, text, tweet_at, screen_name, profile_image_url ]
          )
    self.connection.execute sql
  end
end

$stdin.each do |line|
  json = line.chomp
  next unless json.length > 0
  begin
    tweet = JSON.parse(json)
  rescue JSON::ParserError
    next
  end
  next unless text = tweet["text"]
  next unless text[/\p{Hiragana}/]
  Tweet.add tweet
end
