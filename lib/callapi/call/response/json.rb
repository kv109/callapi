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
end