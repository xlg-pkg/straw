# frozen_string_literal: true

require "logger"
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

  def self.tracer
    @tracer ||= Tracer.new(logger)
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

  class Tracer
    def initialize(logger)
      @logger = logger
    end

    def trace(defaults = {})
      tracer = TracePoint.new(:call) do |x|
        @logger.debug(defaults.merge({ path: x.path, lineno: x.lineno, clazz: x.defined_class, method: x.method_id, args: args_from(x), locals: locals_from(x) }))
      rescue StandardError => boom
        @logger.error(defaults.merge({ message: boom.message, stacktrace: boom.backtrace }))
      end
      tracer.enable
      yield
    ensure
      tracer.disable
    end

    private

    def args_from(trace)
      trace.parameters.map(&:last).map { |x| [x, trace.binding.eval(x.to_s)] }.to_h
    end

    def locals_from(trace)
      trace.binding.local_variables.map { |x| [x, trace.binding.local_variable_get(x)] }.to_h
    end
  end
end
