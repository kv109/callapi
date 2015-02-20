# Change it to Callapi::Call::Parser::Base
class Callapi::Call::Parser
  require_relative 'response/plain'
  require_relative 'response/json'
  require_relative 'response/json/as_object'

  extend Forwardable

  def_delegators :@response, :body, :code

  def initialize(response)
    @response = response
  end

  def data
    return @data if @data

    raise_error unless ok?
    return nil if no_content?

    @data = parse
  end

  def status
    code.to_i
  end

  private

  def parse
    raise NotImplementedError
  end

  def ok?
    status < 300
  end

  def no_content?
    return true if body.nil?
    body.strip.empty?
  end

  def raise_error
    error_class = Callapi::Errors.error_by_status(status)
    raise error_class.new(status, error_message)
  end

  def error_message
    "response body: \"#{body}\""
  end
end