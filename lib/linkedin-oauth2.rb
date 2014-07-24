require "oauth2"
require "linked_in/version"
require "linked_in/configuration"

module LinkedIn
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield self.config
  end
end
