require 'spec_helper'

describe Callapi::Call::RequestMetadata do
  before(:all) do
    Get::Users::Details = Class.new(Callapi::Call::Base)
    Get::Users::IdParam = Class.new(Callapi::Call::Base)
    Get::Users::IdParam::Posts = Class.new(Callapi::Call::Base)
    Get::Users::IdParam::Posts::PostIdParam = Class.new(Callapi::Call::Base)
    ClassWithoutHttpNamespace = Class.new(Callapi::Call::Base)
  end

  let(:metadata) { described_class.new(@call_class.new) }

  context '#request_method' do
    subject { metadata.request_method }

    context 'when call class has namespace equal to some HTTP method' do
      let(:metadata) { described_class.new(Get::Users.new) }

      it 'should take HTTP method from this namespace' do
        expect(subject).to eql(:get)
      end
    end

    context 'when call class does not have namespace equal to some HTTP method' do
      let(:metadata) { described_class.new(ClassWithoutHttpNamespace.new) }

      it 'should raise UnknownHttpMethod error' do
        expect{ subject }.to raise_error { Callapi::Call::Errors::UnknownHttpMethod }
      end
    end
  end

  context '#request_path' do
    subject { metadata.request_path }
    let(:metadata) { described_class.new(Get::Users::Details.new) }

    it 'should be equal to underscored class name with its namespaces' do
      expect(subject).to eql('/users/details')
    end

    context 'when class name contain "Param" string' do
      let(:metadata) { described_class.new(Get::Users::IdParam::Posts::PostIdParam.new(id: 123, post_id: 456)) }

      it 'should use this param value to create path' do
        expect(subject).to eql('/users/123/posts/456')
      end

      context 'but required param is not provided' do
        let(:metadata) { described_class.new(Get::Users::IdParam::Posts::PostIdParam.new(post_id: 456)) }

        it 'should raise MissingParam error' do
          expect{ subject }.to raise_error{Callapi::Call::Errors::MissingParam}
        end
      end
    end
  end
end