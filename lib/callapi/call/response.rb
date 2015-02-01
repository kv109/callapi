# Change it to Callapi::Call::Response::Base
class Callapi::Call::Response
  require_relative 'response/plain'
  require_relative 'response/json'
  require_relative 'response/json/as_object'

  extend Memoist
  extend Forwardable

  def_delegators :@response, :body, :code

  def initialize(response)
    @response = response
  end

  def data
    raise_error unless ok?
    return nil if no_content?

    parse
  end
  memoize :data

  def status
    code.to_i
  end
  memoize :status

  private

  def parse
    raise NotImplementedError
  end

  def ok?
    status < 300
  end
  memoize :ok?

  def no_content?
    return true if body.nil?
    body.strip.empty?
  end
  memoize :no_content?

  def raise_error
    error_class = Callapi::Call::Errors.error_by_status(status)
    raise error_class.new(status, error_message)
  end

  def error_message
    "response body: \"#{body}\""
  end
end