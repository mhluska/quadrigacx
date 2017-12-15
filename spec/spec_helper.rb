require 'vcr'
require 'quadrigacx'

RSpec.configure do |config|
  config.color = true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

QuadrigaCX.configure do |config|
  config.client_id  = "client_id"
  config.api_key    = "api_key"
  config.api_secret = "api_secret"
end
