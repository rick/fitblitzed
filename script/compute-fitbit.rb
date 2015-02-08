#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__)), "..", "lib")
require "rubygems"
require "bundler/setup"
require "fitblitzed/fitbit"

fitbit = FitBlitzed::FitBit.new
total_beers = fitbit.total_beers
puts "Earned #{total_beers} beers."
