require "rubygems"
require "bundler/setup"
require "yaml"

module FitBlitzed
  class ConfigService
    attr_reader :config, :handle, :data

    def initialize(config, handle)
      raise ArgumentError, "configuration does not include data for service [#{handle}]" unless config.config[handle]
      @data   = config.config[handle]
      @config = config
      @handle = handle
    end

    def method_missing(meth, *args)
      # predicate methods: is the key in the configuration?
      if meth[-1] == "?"
        config.config[handle].has_key?(meth[0..-2].to_sym)
      else
        # return the value if the key is in the configuration
        if config.config[handle].has_key?(meth)
          config.config[handle][meth]
        end
      end
    end
  end

  class Config
    attr_reader :config

    def service(handle)
      FitBlitzed::ConfigService.new(self, handle)
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
