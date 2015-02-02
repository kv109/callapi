require 'spec_helper'

describe Callapi::Call::Parser::Plain do
  context '#data' do
    before do
      Callapi::Config.configure do |config|
        config.api_host = 'http://api.org'
      end

      Callapi::Routes.draw do
        get 'plain', parser: Callapi::Call::Parser::Plain
      end

      stub_request(:get, 'http://api.org/plain').to_return(status: 200, body: 'some response')
    end

    subject { get_plain_call.response.data }

    it 'should return response body' do
      expect(subject).to eql ( 'some response' )
    end
  end
end