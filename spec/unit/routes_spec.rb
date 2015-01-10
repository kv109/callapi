require 'spec_helper'

describe Callapi::Routes do
  context '#get' do
    context 'should create new class' do

      before do
        described_class.draw do
          get 'version'
        end
      end

      it 'which inherits from Call::Base' do
        expect( Callapi::Get::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end

    context 'options' do
      context ':strategy' do

        before do
          described_class.draw do
            get 'users', strategy: Callapi::Call::Request::Mock
          end
        end

        it 'should set request strategy for created call' do
          expect( Callapi::Get::Users.strategy ).to eql(Callapi::Call::Request::Mock)
        end
      end
    end
  end

  context '#namespace' do
    before do
      described_class.draw do
        namespace :users do
          namespace :posts do
            get 'index'
          end
        end
      end
    end

    it 'should surround created call with namespace' do
      expect( Callapi::Get::Users::Posts::Index.superclass ).to eql(Callapi::Call::Base)
    end
  end
end
