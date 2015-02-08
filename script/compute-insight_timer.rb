#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__)), "..", "lib")
require "rubygems"
require "bundler/setup"
require "fitblitzed/insight_timer"

insight_timer = FitBlitzed::InsightTimer.new
meditated_today = insight_timer.minutes_meditated(Date.today)
puts "Meditated #{meditated_today} minutes today."
