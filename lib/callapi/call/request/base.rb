class Callapi::Call::Request::Base
  extend Forwardable

  def_delegators :@context, :request_method, :request_path, :params, :headers

  def initialize(context)
    @context = context
  end

  def response
    raise NotImplementedError
  end
end