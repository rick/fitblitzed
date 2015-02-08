#!/usr/bin/env ruby

$:.unshift("lib")
require "fitblitzed/insight_timer"

insight_timer = FitBlitzed::InsightTimer.new
meditated_today = insight_timer.minutes_meditated(Date.today)
puts "Meditated #{meditated_today} minutes today."
