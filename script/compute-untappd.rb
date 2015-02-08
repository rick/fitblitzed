#!/usr/bin/env ruby

$:.unshift(File.join(File.basename(File.dirname(__FILE__)), "..", "lib"))
require "rubygems"
require "bundler/setup"
require "fitblitzed/untappd"

untappd = FitBlitzed::Untappd.new
total_beers = untappd.total_beers
puts "Drank #{total_beers} beers."
