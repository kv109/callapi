require 'spec_helper'

describe Callapi::Call::RequestMetadata do
  before(:all) do
    @call_class = Get::Users
  end

  let(:metadata) { described_class.new(@call_class.new) }

  context '#request_method' do
    subject { metadata.request_method }

    context 'when call class has namespace equal to some HTTP method' do
      it 'should take HTTP method from this namespace' do
        expect(subject).to eql(:get)
      end
    end

    context 'when call class does not have namespace equal to some HTTP method' do
      before do
        @call_class = ClassWithoutHttpNamespace = Class.new(Callapi::Call::Base)
      end

      it 'should raise UnknownHttpMethod error' do
        expect{ subject }.to raise_error { Callapi::Call::Errors::UnknownHttpMethod }
      end
    end
  end

  context '#request_path' do
    subject { metadata.request_path }

    before do
      Get::ExecutiveUsers = Module.new
      @call_class = Get::ExecutiveUsers::Details = Class.new(Callapi::Call::Base)
    end

    it 'should be equal to underscored class name with its namespaces after the HTTP namespace' do
      expect(subject).to eql('/executive_users/details')
    end
  end
end