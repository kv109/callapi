class Callapi::Call::Request
  require_relative 'request/base'
  require_relative 'request/http'
  require_relative 'request/api'
  require_relative 'request/mock'

  def initialize(context)
    @context = context
  end

  def response
    @context.strategy.new(@context).response
  end
end
