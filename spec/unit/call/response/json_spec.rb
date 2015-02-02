require 'spec_helper'

describe Callapi::Call::Parser::Json do
  context '#data' do
    before do
      config = Callapi::Config
      allow(config).to receive(:api_host).and_return('http://api.org')

      call_class = Get::Users
      @call = call_class.new
    end

    subject { @call.response.data }

    context 'when request body is "{"valid": true, "score": 59}"' do
      before { stub_request(:get, 'http://api.org/users').to_return(status: 200, body: '{"valid": true, "score": 59}') }

      it { expect(subject).to eq ({'valid' => true, 'score' => 59}) }
    end
  end
end