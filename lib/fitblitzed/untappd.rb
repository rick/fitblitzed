# Ideally this approach isn't necessary, but waiting for untappd to authorize
# me an API key.  This is relying on data available only to "supporters"
# (i.e., untappd paid accounts).

require "rubygems"
require "bundler/setup"
require "mechanize"
require "json"
require "fitblitzed/config"

module FitBlitzed
  class Untappd
    attr_reader :config

    def initialize
      @config = FitBlitzed::Config.new :service => :untappd,
        :required => [:username, :password, :start_date]
    end

    def username
      config.username
    end

    def password
      config.password
    end

    def start_date
      config.start_date
    end

    def total_beers
      fetch.inject(0) do |beers, checkin|
        beers += 1 if should_count?(checkin)
        beers
      end
    end

    def fetch
      return JSON.parse(File.read("/Users/rick/Downloads/checkin-report_02_07_15.json")) if ENV['DEVELOPMENT'] # FIXME - I'm on a :plane:!

      json = nil

      agent = Mechanize.new do |a|
        a.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1944.0 Safari/537.36"
      end

      agent.get("https://untappd.com/login") do |page|
        # Submit the login form
        my_page = page.form_with(:action => "https://untappd.com/login") do |form|
          form.field_with(:name => "username").value = username
          form.field_with(:name => "password").value = password
        end.click_button

        # download JSON
        download = "https://untappd.com/export?type=json"

        agent.pluggable_parser.default = Mechanize::Download
        json = agent.get(download).body
      end

      data = JSON.parse(json)
    end

    def should_count?(checkin)
      start = Date.parse(start_date)
      checkin_date = Date.strptime(checkin["created_at"], "%Y-%m-%d")
      return false unless checkin_date >= start
      true
    end
  end
end
