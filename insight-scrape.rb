#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "mechanize"
require "csv"

# Load the existing yml config
config = begin
  YAML.load(File.open("config.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
  exit
end

options = config[:insight_timer]

csv = nil

def is_today?(date_time)
  # TODO: make this more robust against time zones, post-midnight times
  Date.strptime(date_time, "%m/%d/%Y") == Date.today
end

def todays_meditation(csv)
  data = Array(CSV.parse(csv))
  tally = 0
  while day = data.shift
    next if day.empty?

    date_time, minutes, description = *day
    next unless date_time =~ %r{^\d+/\d+/\d+\s+\d+:\d+:\d+$}

    if is_today?(date_time)
      tally += minutes.to_i
    else
      break
    end
  end
  tally
end

agent = Mechanize.new do |a|
  a.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1944.0 Safari/537.36"
end

agent.get("https://insighttimer.com/") do |page|
  # Submit the login form
  my_page = page.form_with(:name => "login_form") do |form|
    form.field_with(:name => "user_session[email]").value = options[:email]
    form.field_with(:name => "user_session[password]").value = options[:password]
  end.click_button

  download = "https://insighttimer.com/users/export"

  agent.pluggable_parser.default = Mechanize::Download
  csv = agent.get(download).body
end

puts "Meditated #{todays_meditation(csv)} minutes today."
