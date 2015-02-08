#!/usr/bin/env ruby

# see: http://fitbitclient.com/guide/playing-with-the-fitgem-api

$:.unshift("lib")
require "fitblitzed/fitbit"

fitbit = FitBlitzed::FitBit.new
total_beers = fitbit.total_beers
puts "Earned #{total_beers} beers."
