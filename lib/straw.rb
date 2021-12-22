# frozen_string_literal: true

require_relative "straw/version"

module Straw
  class Error < StandardError; end

  def self.logger
    @logger ||= Logger.new($stderr, level: ENV.fetch("LOG_LEVEL", Logger::INFO)).tap do |x|
      x.formatter = proc do |_severity, _datetime, _progname, message|
        "[#{VERSION}] #{message}\n"
      end
    end
  end

  module Memoizable
    def memoize(key)
      if memoized?(key)
        instance_variable_get(var_for(key))
      else
        instance_variable_set(var_for(key), yield)
      end
    end

    def memoized?(key)
      instance_variable_defined?(var_for(key))
    end

    private

    def var_for(key)
      "@#{key}"
    end
  end
end
