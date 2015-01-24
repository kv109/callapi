#TODO: replace with MultiJSON
require 'json'

class Callapi::Call::Response::Json < Callapi::Call::Response
  extend Memoist

  def to_struct
    to_hash
  end

  private

  def to_hash
    JSON.parse(body)
  end
  memoize :to_hash

  def error_message
    to_hash['error_message'] rescue super
  end
end