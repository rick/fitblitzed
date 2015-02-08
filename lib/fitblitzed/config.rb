require "rubygems"
require "bundler/setup"
require "yaml"

module FitBlitzed
  class Config
    attr_reader :data, :service, :reader

    class Reader
      attr_reader :data

      def initialize
        @data = read
      end

      def read
        YAML.load(File.open("config.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
        exit
      end
    end

    def initialize(options = {})
      @reader = Reader.new
      raise "No configuration data" unless @data = reader.data
      handle_options(options)
    end

    def handle_options(options)
      # :service => foo limits the configuration data to that service's data
      return unless options[:service]

      @service = options[:service]
      if data.has_key?(service)
        @data = data[service]
      else
        raise ArgumentError, "Configuration does not include data for required service :#{service}"
      end

      # :required => [:a, :b, :c] requires the specified data fields to be
      # present for the specified service
      return unless options[:required]

      options[:required].each do |key|
        unless data.has_key?(key)
          raise ArgumentError, ":#{key} configuration is required for service :#{service}."
        end
      end
    end

    def method_missing(meth, *args)
      # predicate methods: is the key in the configuration?
      if meth[-1] == "?"
        data.has_key?(meth[0..-2].to_sym)
      else
        # return the value if the key is in the configuration
        data[meth] if data.has_key?(meth)
      end
    end
  end
end
