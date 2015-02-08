require 'rubygems'
require 'bundler/setup'
require "fitgem"
require "yaml"
require "fitblitzed/config"

module FitBlitzed
  class FitBit
    attr_reader :config

    def initialize
      config = FitBlitzed::Config.new
      raise ArgumentError, "Configuration data is missing." unless config
      @config = config.service(:fitbit, :required => [:consumer_key, :consumer_secret, :start_date])
    end

    def consumer_key
      config.consumer_key
    end

    def consumer_secret
      config.consumer_secret
    end

    def start_date
      Date.parse(config.start_date)
    end

    def token
      config.token
    end

    def secret
      config.secret
    end

    def user_id
      config.user_id
    end

    def total_beers
      fetch.inject(0) do |tally, day|
        tally += beers_from_steps(day["summary"]["steps"].to_i)
      end
    end

    def fetch
      if ENV['DEVELOPMENT'] # FIXME - I'm on a :plane:!
        return [
          { "summary" => { "steps" => "10000"  } },
          { "summary" => { "steps" => "1000"   } },
          { "summary" => { "steps" => "5000"   } },
          { "summary" => { "steps" => "14999"  } },
          { "summary" => { "steps" => "15000"  } },
          { "summary" => { "steps" => "20000"  } },
          { "summary" => { "steps" => "100000" } },
        ]
      end

      current_date = start_date
      data = []
      client = connect

      while (current_date <= Date.today)
        data << client.activities_on_date(current_date)
        current_date += 1
      end

      data
    end

    def connect
      client = Fitgem::Client.new(config.data)
      access_token = client.reconnect(token, secret)
      client
    rescue => e
      raise "Unable to reconnect to fitbit: #{e}"
    end

    def beers_from_steps(steps)
      return 0 if steps < 10000
      return 1 if steps < 15000
      return 2 if steps < 20000
      3
    end
  end
end

__END__

# TODO: below here is code involved in requesting tokens, etc., and updating the configuration with that new information -- this should become part of #connect

client = Fitgem::Client.new(config[:fitbit])

# With the token and secret, we will try to use them
# to reconstitute a usable Fitgem::Client
if config[:fitbit][:token] && config[:fitbit][:secret]
  begin
    access_token = client.reconnect(config[:fitbit][:token], config[:fitbit][:secret])
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

  config[:fitbit].merge!(:token => access_token.token, :secret => access_token.secret, :user_id => user_id)

  # Write the whole oauth token set back to the config file
  File.open("config.yml", "w") {|f| f.write(config.to_yaml) }
end
