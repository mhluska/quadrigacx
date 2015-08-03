require 'vcr'
require 'dotenv'
require 'quadrigacx'

Dotenv.load

RSpec.configure do |config|
  config.color = true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

QuadrigaCX.configure do |config|
  config.client_id  = ENV['QUADRIGACX_CLIENT_ID']
  config.api_key    = ENV['QUADRIGACX_API_KEY']
  config.api_secret = ENV['QUADRIGACX_API_SECRET']
end
