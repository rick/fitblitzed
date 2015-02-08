#!/usr/bin/env ruby

# Ideally this approach isn't necessary, but waiting for untappd to authorize
# me an API key.  This is relying on data available only to "supporters"
# (i.e., untappd paid accounts).

require "rubygems"
require "bundler/setup"
require "mechanize"
require "json"

def should_count?(options, checkin)
  start_date = Date.parse(options[:start_date])
  checkin_date = Date.strptime(checkin["created_at"], "%Y-%m-%d")
  return false unless checkin_date >= start_date
  true
end

# Load the existing yml config
config = begin
  YAML.load(File.open("config.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
  exit
end

json = nil
options = config[:untappd]

# TODO: check for presence of start date, username, password

agent = Mechanize.new do |a|
  a.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1944.0 Safari/537.36"
end

agent.get("https://untappd.com/login") do |page|
  # Submit the login form
  my_page = page.form_with(:action => "https://untappd.com/login") do |form|
    form.field_with(:name => "username").value = options[:username]
    form.field_with(:name => "password").value = options[:password]
  end.click_button

  # download JSON
  download = "https://untappd.com/export?type=json"

  agent.pluggable_parser.default = Mechanize::Download
  json = agent.get(download).body
end

data = JSON.parse(json)

total_beers = data.inject(0) do |beers, checkin|
  beers += 1 if should_count?(options, checkin)
  beers
end

puts "Drank #{total_beers} beers."
