require "oauth2"
require "linked_in/version"
require "linked_in/configuration"
require "linked_in/errors"
require "linked_in/oauth"

module LinkedIn
  @config = Configuration.new

  class << self
    attr_accessor :config
  end

  def self.configure
    yield self.config
  end
end
