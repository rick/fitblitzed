#!/usr/bin/env ruby

$:.unshift("lib")
require "fitblitzed/untappd"

untappd = FitBlitzed::Untappd.new
total_beers = untappd.total_beers
puts "Drank #{total_beers} beers."
