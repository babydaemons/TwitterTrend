#!/usr/bin/env ruby

require "uri"
require "oauth"
require "net/https"

class Connection
  def initialize(uri, consumer, access_token)
    @https = Net::HTTP.new(uri.host, uri.port)
    @https.use_ssl = true
    @https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    @request = Net::HTTP::Get.new(
        uri.request_uri,
        "Accept-Encoding" => "identity")
    @request.oauth!(@https, consumer, access_token)
  end

  def start(&block)
    @https.start do |http|
      http.request(@request) do |response|
        response.read_body(&block)
      end
    end rescue self
    self
  end
end

uri = URI.parse("https://stream.twitter.com/1.1/statuses/sample.json")
consumer = OAuth::Consumer.new(
    ENV['TWITTER_CONSUMER_KEY'],
    ENV['TWITTER_CONSUMER_SECRET'],
    site: "https://twitter.com")
access_token = OAuth::AccessToken.new(
    consumer,
    ENV['TWITTER_TOKEN_KEY'],
    ENV['TWITTER_TOKEN_SECRET'])

while connection = Connection.new(uri, consumer, access_token)
  connection.start do |str|
    next unless str.bytesize > 0
    $stdout.write(str)
  end
end
