require 'spec_helper'

describe Callapi::Call::Request::Mock do
  context '#response' do
    before do
      call_class = Get::Users
      @call = call_class.new
    end

    subject { described_class.new(@call).response }

    context 'when there is no file with mocked response' do
      it 'should raise CouldNotFoundRequestMockFile error' do
        expect{ subject }.to raise_error { Callapi::Call::Errors::CouldNotFoundRequestMockFile }
      end
    end

    context '#body' do
      subject { described_class.new(@call).response.body }

      before do
        allow(File).to receive(:read).and_return('body from file')
      end

      it 'should be taken from file' do
        expect(subject).to eql('body from file')
      end
    end

    context '#filepath' do
      subject { described_class.new(@call).send(:file_path) }

      it 'should be created based on call HTTP method, request path and response format ' do
        expect(subject).to eql 'mocked_calls/get/users.json'
      end
    end
  end
end