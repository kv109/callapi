require 'spec_helper'

describe Callapi::Call::Base do
  let(:config) { Callapi::Config }
  let(:call) { described_class.new }

  context '#initialize' do
    it 'should take params as an argument' do
      expect(described_class.new(some_param: :some_value).params).to eql(some_param: :some_value)
    end
  end

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

    before { call.with_response_parser(Callapi::Call::Parser::Json::AsObject) }

    it 'should be accessible' do
      expect(subject).to eql(Callapi::Call::Parser::Json::AsObject)
    end
  end
end