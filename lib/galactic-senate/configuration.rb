# frozen_string_literal: true

module GalacticSenate
  class Configuration

    attr_accessor :redis, :logger

    def initialize
      @redis = nil
      @logger = nil
    end
  end
end