require "cgi"
require "json"

require "oauth2"
require "linked_in/version"

module LinkedIn
  class << self
    attr_accessor :config
  end

  def self.foo
    puts "FOO BAR"
  end

  def self.configure
    self.config ||= Configuration.new
    yield self.config
  end
end
