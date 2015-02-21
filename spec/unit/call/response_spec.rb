require 'spec_helper'

describe Callapi::Call::Parser do
  before do
    config = Callapi::Config
    allow(config).to receive(:api_host).and_return('http://api.org')

    @call = Get::Users.new
  end

  context 'caching response' do
    before do
      stub_request(:get, 'http://api.org/users').to_return(status: 200, body: '{"json": true}')
    end

    it 'should not parse response twice unless call is reloaded' do
      cached_response = {'json' => true}
      expect(@call.data).to eql cached_response
      @call.response_parser = Callapi::Call::Parser::Plain
      expect(@call.data).to eql cached_response
      @call.reload
      expect(@call.data).to eql '{"json": true}'
    end

  end

  context '#data' do
    subject { @call.data }

    context 'when API returned 5xx' do
      before do
        stub_request(:get, 'http://api.org/users').to_return(status: 500)
      end

      it 'should raise ServerError error' do
        expect{ subject }.to raise_error { Callapi::ServerError }
      end
    end

    context 'when API returned 4xx' do
      before do
        stub_request(:get, 'http://api.org/users').to_return(status: 400)
      end

      it 'should raise ClientError error' do
        expect{ subject }.to raise_error { Callapi::ClientError }
      end
    end

    context 'when API returned 401' do
      before do
        stub_request(:get, 'http://api.org/users').to_return(status: 401)
      end

      it 'should raise NotAuthorized error' do
        expect{ subject }.to raise_error { Callapi::NotAuthorizedError }
      end
    end
  end
end