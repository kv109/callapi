require 'spec_helper'

describe Callapi::Routes do
  context '#get' do
    let(:args) { ['version'] }

    before do
      arguments = args.dup
      described_class.draw do
        get *(arguments)
      end
    end

    context 'should create new class' do
      it 'which inherits from Call::Base' do
        expect( Callapi::Get::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end
  end

  context '#namespace' do
    let(:args) { ['version'] }

    before do
      arguments = args.dup
      described_class.draw do
        namespace :users do
          namespace :posts do
            get *(arguments)
          end
        end
      end
    end

    it 'should create namespace' do
      expect{ Callapi::Get::Users::Posts }.to_not raise_error{ NameError }
      expect( Callapi::Get::Users::Posts.superclass ).to eql(Callapi::Call::Base)
    end
  end
end
