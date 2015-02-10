require_relative 'request_metadata'

class Callapi::Call::Base
  require_relative 'request'
  require_relative 'response'

  extend Forwardable

  def_delegators :request_metadata, :request_method, :request_path

  chain_attr_accessor :params, :headers, hash: true, prefix: 'add'
  chain_attr_accessor :response_parser, :strategy

  def initialize(params = {})
    add_params(params)
  end

  def response
    @response ||= build_response
  end

  def strategy
    @strategy ||= (self.class.strategy || Callapi::Config.default_request_strategy)
  end

  def response_parser
    @response_parser ||= (self.class.response_parser || Callapi::Config.default_response_parser)
  end

  def self.strategy=(strategy)
    @strategy = strategy
  end

  def self.strategy
    @strategy
  end

  def self.response_parser=(response_parser)
    @response_parser = response_parser
  end

  def self.response_parser
    @response_parser
  end

  def reload
    @response = nil
  end

  private

  def build_response
    response_parser.new(request_class.new(self).response)
  end

  #TODO: Should be replaced with #strategy. There is no need for additional class between Base and actual strategy, for now Callapi::Call::Request is such unnecessary class.
  def request_class
    Callapi::Call::Request
  end

  def request_metadata
    @request_metadata ||= Callapi::Call::RequestMetadata.new(self)
  end
end