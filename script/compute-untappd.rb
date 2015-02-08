#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
$:.unshift("lib")
require "fitblitzed/untappd"

untappd = FitBlitzed::Untappd.new
total_beers = untappd.total_beers
puts "Drank #{total_beers} beers."
