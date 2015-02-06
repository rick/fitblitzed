#!/usr/bin/env ruby

# see: http://fitbitclient.com/guide/playing-with-the-fitgem-api

require 'rubygems'
require 'bundler/setup'
require "fitgem"
require "yaml"

# Load the existing yml config
config = begin
  Fitgem::Client.symbolize_keys(YAML.load(File.open("config.yml")))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
  exit
end

client = Fitgem::Client.new(config[:oauth])

# With the token and secret, we will try to use them
# to reconstitute a usable Fitgem::Client
if config[:oauth][:token] && config[:oauth][:secret]
  begin
    access_token = client.reconnect(config[:oauth][:token], config[:oauth][:secret])
  rescue Exception => e
    puts "Error: Could not reconnect Fitgem::Client due to invalid keys in .fitgem.yml"
    exit
  end
# Without the secret and token, initialize the Fitgem::Client
# and send the user to login and get a verifier token
else
  request_token = client.request_token
  token = request_token.token
  secret = request_token.secret

  puts "Go to http://www.fitbit.com/oauth/authorize?oauth_token=#{token} and then enter the verifier code below"
  verifier = gets.chomp

  begin
    access_token = client.authorize(token, secret, { :oauth_verifier => verifier })
  rescue Exception => e
    puts "Error: Could not authorize Fitgem::Client with supplied oauth verifier"
    exit
  end

  puts 'Verifier is: '+verifier
  puts "Token is:    "+access_token.token
  puts "Secret is:   "+access_token.secret

  user_id = client.user_info['user']['encodedId']
  puts "Current User is: "+user_id

  config[:oauth].merge!(:token => access_token.token, :secret => access_token.secret, :user_id => user_id)

  # Write the whole oauth token set back to the config file
  File.open(".fitgem.yml", "w") {|f| f.write(config.to_yaml) }
end

# ============================================================
# Add Fitgem API calls on the client object below this line

def beers_from_steps(steps)
  return 0 if steps < 10000
  return 1 if steps < 17500
  return 2 if steps < 22000
  3
end

current_date = Date.new(2015,1,26)

while current_date <= Date.today
  data = client.activities_on_date current_date
  steps = data["summary"]["steps"]
  puts "#{current_date.to_s} had #{steps} steps, for #{beers_from_steps(steps)} beers."
  current_date += 1
end