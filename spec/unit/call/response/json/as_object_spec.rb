require 'spec_helper'

describe Callapi::Call::Parser::Json::AsObject do
  context '#data' do
    before do
      config = Callapi::Config
      allow(config).to receive(:api_host).and_return('http://api.org')
      allow(config).to receive(:default_response_parser).and_return(described_class)

      @call = Get::Users.new
    end

    subject { @call.response.data }

    context 'when request body is "{"valid": true, "score": 59}"' do
      before { stub_request(:get, 'http://api.org/users').to_return(status: 200, body: '{"valid": true, "score": 59}') }

      it 'should return object with #valid and #score methods' do
        expect(subject.valid).to eq (true)
        expect(subject.score).to eq (59)
      end
    end

    context 'when request body is "[{"score": 59}, {"score": 60}]"' do
      before { stub_request(:get, 'http://api.org/users').to_return(status: 200, body: '[{"score": 59}, {"score": 60}]') }

      it 'should return array of objects with #score method' do
        expect(subject[0].score).to eq (59)
        expect(subject[1].score).to eq (60)
      end
    end

    context '#keys_excluded_from_parsing' do
      context 'when set to ["translations"]' do
        before { described_class.keys_excluded_from_parsing = ['translations'] }

        context 'and request body is "{"valid": true, "translations": {"a": "A"}}"' do
          before { stub_request(:get, 'http://api.org/users').to_return(status: 200, body: '{"valid": true, "translations": {"a": "A"}}') }

          it 'should should not create object from #translations' do
            expect(subject.valid).to eq (true)
            expect(subject.translations).to eq ({'a' => 'A'})
          end
        end
      end
    end
  end
end