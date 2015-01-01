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
        expect( Get::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end

  end
end
