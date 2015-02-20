require 'spec_helper'

describe Callapi::Routes do
  before(:all) do
    described_class.draw do
      get 'version'
      post 'version'
      put :version
      delete :version
      patch :version

      get 'users', strategy: Callapi::Call::Request::Mock, parser: Callapi::Call::Parser::Plain
      get 'users/:id'
      namespace :users do
        get ':id/posts/:post_id'
        get ':id/posts/:post_id/details'
        namespace :posts do
          get 'index'
        end
      end

      get 'orders/:id'
      get 'orders'
    end
  end

  context '#get "version"' do
    it 'should create Callapi::Get::Version which inherits from Call::Base' do
      expect( Callapi::Get::Version.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #get_version_call method which returns Callapi::Get::Version instance' do
      expect( get_version_call ).to be_instance_of(Callapi::Get::Version)
    end
  end

  context '#post "version"' do
    it 'should create Callapi::Post::Version which inherits from Call::Base' do
      expect( Callapi::Post::Version.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #post_version_call method which returns Callapi::Post::Version instance' do
      expect( post_version_call ).to be_instance_of(Callapi::Post::Version)
    end
  end

  context '#put "version"' do
    it 'should create Callapi::Put::Version which inherits from Call::Base' do
      expect( Callapi::Put::Version.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #put_version_call method which returns Callapi::Put::Version instance' do
      expect( put_version_call ).to be_instance_of(Callapi::Put::Version)
    end
  end
  
  context '#patch "version"' do
    it 'should create Callapi::Patch::Version which inherits from Call::Base' do
      expect( Callapi::Patch::Version.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #patch_version_call method which returns Callapi::Patch::Version instance' do
      expect( patch_version_call ).to be_instance_of(Callapi::Patch::Version)
    end
  end

  context '#delete "version"' do
    it 'should create Callapi::Delete::Version which inherits from Call::Base' do
      expect( Callapi::Delete::Version.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #delete_version_call method which returns Callapi::Delete::Version instance' do
      expect( delete_version_call ).to be_instance_of(Callapi::Delete::Version)
    end
  end
  
  context 'route options' do
    context '#get "users", strategy: Callapi::Call::Request::Mock' do
      it 'should set Callapi::Get::Users.strategy to Callapi::Call::Request::Mock' do
        expect( Callapi::Get::Users.strategy ).to eql(Callapi::Call::Request::Mock)
      end
    end

    context '#get "users", parser: Callapi::Call::Parser::Plain' do
      it 'should set Callapi::Get::Users.response_parser to Callapi::Call::Parser::Plain' do
        expect( Callapi::Get::Users.response_parser ).to eql(Callapi::Call::Parser::Plain)
      end
    end
  end

  context '#namespace :users { namespace :posts { get "index" } }' do
    it 'should create Callapi::Get::Users::Posts::Index' do
      expect( Callapi::Get::Users::Posts::Index.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #get_users_posts_index_call method' do
      expect( get_users_posts_index_call ).to be_instance_of(Callapi::Get::Users::Posts::Index)
    end
  end

  context '#get "users/:id"' do
    it 'should create Callapi::Get::Users::IdParam class' do
      expect( Callapi::Get::Users::IdParam.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #get_users_by_id method' do
      expect( get_users_by_id_call ).to be_instance_of(Callapi::Get::Users::IdParam)
    end
  end

  context '#get "users/:id/posts/:post_id"' do
    it 'should create Callapi::Get::Users::Posts::PostIdParam class' do
      expect( Callapi::Get::Users::IdParam::Posts::PostIdParam.superclass ).to eql(Callapi::Call::Base)
    end

    it 'should create #get_users_by_id method' do
      expect( get_users_by_id_posts_by_post_id_call ).to be_instance_of(Callapi::Get::Users::IdParam::Posts::PostIdParam)
    end
  end

  context '#get "users/:id/posts/:post_id/details"' do
    it 'should create Callapi::Get::Users::Posts::PostIdParam::Details class' do
      expect( Callapi::Get::Users::IdParam::Posts::PostIdParam::Details.superclass ).to eql(Callapi::Call::Base)
    end
  end

  context '#get("orders/:id") and get("orders") in this direct order' do
    context '#get "orders/:id"' do
      it 'should create Callapi::Get::Orders::IdParam class' do
        expect( Callapi::Get::Orders::IdParam.superclass ).to eql(Callapi::Call::Base)
      end

      it 'should create #get_orders_by_id method' do
        expect( get_orders_by_id_call ).to be_instance_of(Callapi::Get::Orders::IdParam)
      end
    end

    context '#get "orders"' do
      it 'should create Callapi::Get::Orders class' do
        expect( Callapi::Get::Orders.superclass ).to eql(Callapi::Call::Base)
      end

      it 'should create #get_orders method' do
        expect( get_orders_call ).to be_instance_of(Callapi::Get::Orders)
      end
    end
  end
end
