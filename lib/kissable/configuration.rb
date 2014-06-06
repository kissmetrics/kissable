require 'logger'

module Kissable
  class Configuration
    attr_accessor :logger, :domain

    def initialize
      @logger = Logger.new(STDOUT)
      @domain = nil
    end
  end
end