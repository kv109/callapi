require 'webmock/rspec'

require_relative '../lib/callapi'

RSpec.configure do |config|
  config.before(:suite) do
    Get = Module.new
    Get::Users = Class.new(Callapi::Call::Base)
  end
end