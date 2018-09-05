# frozen_string_literal: true

require "galactic-senate/version"
require "galactic-senate/configuration"
require "galactic-senate/delegation"

module GalacticSenate
  class << self
    attr_accessor :config, :whoami
  end

  def self.config
    @config ||= GalacticSenate::Configuration.new
  end

  def self.reset
    @config = GalacticSenate::Configuration.new
  end

  def self.configure
    yield(config)
  end

  def self.whoami
    @whoami ||= "#{Socket.gethostname}:#{$$}:#{SecureRandom.hex(3)}"
  end
end



