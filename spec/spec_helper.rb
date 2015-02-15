require 'webmock/rspec'

require_relative '../lib/callapi'

RSpec.configure do |config|
  config.before(:suite) do
    Get = Module.new
    Get::Users = Class.new(Callapi::Call::Base)

    Callapi::Config.configure do |config|
      config.log_level = :none
    end
  end
end