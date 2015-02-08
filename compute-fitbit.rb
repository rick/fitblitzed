#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
$:.unshift("lib")
require "fitblitzed/fitbit"

fitbit = FitBlitzed::FitBit.new
total_beers = fitbit.total_beers
puts "Earned #{total_beers} beers."
