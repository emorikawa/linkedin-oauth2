# This file is required by all tests
require 'linkedin-oauth2'

# Record and playback LinkedIn API calls
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
end

require 'webmock/rspec'

# https://coveralls.io/r/emorikawa/linkedin-oauth2
require 'coveralls'
Coveralls.wear!
