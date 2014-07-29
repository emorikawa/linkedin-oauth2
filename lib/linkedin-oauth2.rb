require "oauth2"
require "linked_in/version"
require "linked_in/configuration"
require "linked_in/errors"
require "linked_in/oauth"
require "linked_in/access_token"

require "linked_in/api_endpoints/people"
require "linked_in/api_endpoints/path_builders"
require "linked_in/api"

module LinkedIn
  @config = Configuration.new

  class << self
    attr_accessor :config
  end

  def self.configure
    yield self.config
  end
end
