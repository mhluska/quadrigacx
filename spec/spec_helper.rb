require 'vcr'
require 'dotenv'
require_relative '../lib/quadrigacx'

Dotenv.load

RSpec.configure do |config|
  config.color = true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
