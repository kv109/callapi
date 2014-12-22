require_relative 'request_metadata'

class Callapi::Call::Base
  require_relative 'request'
  require_relative 'response'

  extend Forwardable
  extend Memoist

  def_delegators :request_metadata, :request_method, :request_path

  chain_attr_accessor :params, :headers, hash: true, prefix: 'add'
  chain_attr_accessor :response_class, :strategy

  def response
    build_response
  end
  memoize :response

  def strategy
    @strategy ||= Callapi::Config.default_request_strategy
  end

  def request_metadata
    Callapi::Call::RequestMetadata.new(self)
  end
  memoize :request_metadata

  def response_class
    @response_class ||= Callapi::Config.default_response_class
  end

  private

  def build_response
    response_class.new(request_class.new(self).response)
  end

  #TODO: Should be replaced with #strategy. There is no need for additional class between Base and actual strategy, for now Callapi::Call::Request is such unnecessary class.
  def request_class
    Callapi::Call::Request
  end
end