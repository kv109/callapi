# Change it to Callapi::Call::Response::Base
class Callapi::Call::Response
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

    to_struct
  end

  def status
    code.to_i
  end
  memoize :status

  private

  def to_struct
    raise NotImplementedError
  end

  def ok?
    status < 400
  end
  memoize :ok?

  def api_crashed?
    status >= 500
  end

  def no_content?
    body.nil? || body.empty?
  end
  memoize :no_content?

  def raise_error
    error_class = Callapi::Call::Errors.error_by_status(status)
    raise error_class.new(error_messages.join(', '))
  end

  def error_messages
    return [] if api_crashed?
    return [] if no_content?

    to_struct.errors || []
  end
end