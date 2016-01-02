#!/usr/bin/env ruby

require "json"
require "time"

$stdout.sync = true

$stdin.each do |line|
  str = line.chomp
  next unless str.length > 0
  begin
    obj = JSON.parse(str)
  rescue JSON::ParserError
    next
  end
  next unless text = obj["text"]
  next unless text[/\p{Hiragana}/]
  time = Time.parse(obj["created_at"]).getlocal
  puts text
  puts "[#{time}] #{obj["id"]}"
end
