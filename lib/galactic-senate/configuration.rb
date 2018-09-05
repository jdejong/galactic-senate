# frozen_string_literal: true

module GalacticSenate
  class Configuration

    attr_accessor :redis, :logger, :events

    def initialize
      @redis = nil
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
      @events = {
          elected: [],
          ousted: [],
          supreme_chancellor_changed: []
      }
    end


    def on(event, &block)
      raise ArgumentError, "Invalid event: #{event}" unless @events.key?(event) && event.is_a?(Symbol)
      @events[event] << block
    end

  end
end