require "rubygems"
require "bundler/setup"
require "yaml"

module FitBlitzed
  class ConfigService
    attr_reader :config, :handle, :data

    def initialize(config, handle, options = {})
      raise ArgumentError, "Configuration does not include data for required service :#{handle}" unless config.config[handle]

      @data   = config.config[handle]
      @config = config
      @handle = handle

      if options[:required]
        options[:required].each do |key|
          unless data.has_key?(key)
            raise ArgumentError, ":#{key} configuration is required for service :#{handle}."
          end
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

  class Config
    attr_reader :config

    def service(handle, options = {})
      FitBlitzed::ConfigService.new(self, handle, options)
    end

    def config
      @config ||= read
    end

    def read
      @config = begin
        YAML.load(File.open("config.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
        exit
      end
    end
  end
end
