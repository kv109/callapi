require 'spec_helper'

describe Callapi::Call::Request::Api do
  let(:config) { Callapi::Config }

  context '#host' do
    subject { described_class.new(nil).host }

    context 'when API host is not set' do
      it 'should raise ApiHostNotSet error' do
        expect { subject }.to raise_error { Callapi::ApiHostNotSetError }
      end
    end

    context 'when API host is set' do
      before { allow(config).to receive(:api_host).and_return('http://api.org') }

      it 'should take API host from config' do
        expect( subject ).to eql 'http://api.org'
      end
    end
  end

  context '#api_path_prefix' do
    subject { described_class.new(nil).api_path_prefix }

    it 'should take API path prefix from API host' do
      allow(config).to receive(:api_host).and_return('http://api.org/api/v1')
      expect( subject ).to eql '/api/v1'
    end
  end

  context '#response' do
    before do
      allow(config).to receive(:request_strategy).and_return(described_class)
      allow(config).to receive(:api_host).and_return('http://api.org')
      stub_request(:get, 'http://api.org/users').to_return(status: 200, body: '')

      call_class = Get::Users
      @call = call_class.new
    end

    subject { described_class.new(@call).response }

    it 'should get response from server' do
      expect( subject.body ).to eql(nil)
      expect( subject.code ).to eql('200')
    end
  end
end