require 'spec_helper'

describe Callapi::Routes do
  before(:all) do
    described_class.draw do
      get 'version'
      post 'version'
      put 'version'
      delete 'version'
      patch 'version'
      get 'users', strategy: Callapi::Call::Request::Mock
      namespace :users do
        namespace :posts do
          get 'index'
        end
      end
    end
  end

  context '#get' do

    context 'should create new class with Callapi::Get namespace' do
      it 'which inherits from Call::Base' do
        expect( Callapi::Get::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end

    context 'helper_method' do
      it 'should return instance of created class' do
        expect( get_version_call ).to be_instance_of(Callapi::Get::Version)
        expect( get_version_call(some_param: :some_value).params ).to eql(some_param: :some_value)
      end
    end

  end

  context '#post' do
    context 'should create new class with Callapi::Post namespace' do
      it 'which inherits from Call::Base' do
        expect( Callapi::Post::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end
  end

  context '#put' do
    context 'should create new class with Callapi::Put namespace' do
      it 'which inherits from Call::Base' do
        expect( Callapi::Put::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end
  end

  context '#delete' do
    context 'should create new class with Callapi::Delete namespace' do
      it 'which inherits from Call::Base' do
        expect( Callapi::Delete::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end
  end

  context '#patch' do
    context 'should create new class with Callapi::Patch namespace' do
      it 'which inherits from Call::Base' do
        expect( Callapi::Patch::Version.superclass ).to eql(Callapi::Call::Base)
      end
    end
  end

  context 'options' do
    context ':strategy' do
      it 'should set request strategy for created call' do
        expect( Callapi::Get::Users.strategy ).to eql(Callapi::Call::Request::Mock)
      end
    end
  end

  context '#namespace' do
    it 'should surround created call with namespace' do
      expect( Callapi::Get::Users::Posts::Index.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create helper method which name includes namespace' do
      expect( get_users_posts_index_call ).to be_instance_of(Callapi::Get::Users::Posts::Index)
    end
  end
end
