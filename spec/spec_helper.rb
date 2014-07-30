# This file is required by all tests
require 'linkedin-oauth2'

# Record and playback LinkedIn API calls
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
end

require 'webmock/rspec'

require_relative "linked_in/api_helpers"
RSpec.configure do |rspec|
  rspec.extend APIHelpers, helpers: :api
end
