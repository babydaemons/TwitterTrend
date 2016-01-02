#!/bin/sh
(./sample_stream.rb | ./filter_tweet.rb) </dev/null 1>sample_stream_add.log 2>&1 &
