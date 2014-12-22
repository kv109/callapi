require 'spec_helper'

describe Callapi::Call::Response do
  context '#data' do
    before do
      config = Callapi::Config
      allow(config).to receive(:api_host).and_return('http://api.org')

      call_class = Get::Users
      @call = call_class.new
    end

    subject { @call.response.data }

    context 'when API returned 500' do
      before do
        stub_request(:get, 'http://api.org/users').to_return(status: 500)
      end

      it 'should raise ApiCrashed error' do
        expect{ subject }.to raise_error { Callapi::Call::Errors::ApiCrashed }
      end
    end

    context 'when API returned 401' do
      before do
        stub_request(:get, 'http://api.org/users').to_return(status: 401)
      end

      it 'should raise NotAuthorized error' do
        expect{ subject }.to raise_error { Callapi::Call::Errors::NotAuthorized }
      end
    end

  end
end