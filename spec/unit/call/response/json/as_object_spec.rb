require 'spec_helper'

describe Callapi::Call::Response::Json::AsObject do
  context '#data' do
    before do
      config = Callapi::Config
      allow(config).to receive(:api_host).and_return('http://api.org')
      allow(config).to receive(:default_response_class).and_return(described_class)
      stub_request(:get, 'http://api.org/users').to_return(status: 200, body: '{"json": true}')

      call_class = Get::Users
      @call = call_class.new
    end

    subject { @call.response.data }

    it 'should return object created from JSON' do
      expect(subject.json).to eql ( true )
    end
  end
end