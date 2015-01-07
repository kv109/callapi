require 'spec_helper'

describe Callapi::Call::Base do
  let(:config) { Callapi::Config }
  let(:call) { described_class.new }

  context '#strategy' do
    before { allow(config).to receive(:request_strategy).and_return(Callapi::Call::Request::Api) }

    it 'should be taken from config' do
      expect(subject.strategy).to eql(Callapi::Call::Request::Api)
    end
  end

  context '.strategy' do
    before { described_class.strategy = Callapi::Call::Request::Mock }

    it 'should overwrite default strategy for each instance' do
      expect(subject.strategy).to eql(Callapi::Call::Request::Mock)
    end
  end

  context '#response_parser' do
    subject { call.response_parser }

    before { call.with_response_parser(Callapi::Call::Response::Json::AsObject) }

    it 'should be accessible' do
      expect(subject).to eql(Callapi::Call::Response::Json::AsObject)
    end
  end
end