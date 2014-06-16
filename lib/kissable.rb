require "kissable/version"
require "kissable/configuration"
require "kissable/ab"
require "kissable/sinatra_cookie_adapter"

module Kissable
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
