require "mechanize"
require "csv"
require "fitblitzed"

module FitBlitzed
  class InsightTimer
    attr_reader :config

    def initialize
      @config = FitBlitzed::Config.new :service => :insight_timer,
        :required => [:email, :password]
    end

    def email
      config.email
    end

    def password
      config.password
    end

    def minutes_meditated(target_date)
      data = fetch

      tally = 0
      while day = data.shift
        next if day.empty?

        date_time, minutes, description = *day
        next unless date_time =~ %r{^\d+/\d+/\d+\s+\d+:\d+:\d+$}

        if is_date?(date_time, target_date)
          tally += minutes.to_i
        else
          break
        end
      end
      tally
    end

    def fetch
      csv = nil

      if ENV['DEVELOPMENT']
        # FIXME -- I'm on a :plane:!
        csv = File.read("/Users/rick/Downloads/insight_connect_export.csv")
      else
        agent = Mechanize.new do |a|
          a.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1944.0 Safari/537.36"
        end

        agent.get("https://insighttimer.com/") do |page|
          # Submit the login form
          my_page = page.form_with(:name => "login_form") do |form|
            form.field_with(:name => "user_session[email]").value = email
            form.field_with(:name => "user_session[password]").value = password
          end.click_button

          download = "https://insighttimer.com/users/export"

          agent.pluggable_parser.default = Mechanize::Download
          csv = agent.get(download).body
        end
      end

      Array(CSV.parse(csv))
    end

    def is_date?(date_time_string, target_date)
      # TODO: make this more robust against time zones, post-midnight times
      Date.strptime(date_time_string, "%m/%d/%Y") == target_date
    end
  end
end
