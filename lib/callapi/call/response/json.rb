require 'multi_json'

class Callapi::Call::Response::Json < Callapi::Call::Response
  def parse
    to_hash
  end

  private

  def to_hash
    @to_hash ||= MultiJson.load(body)
  end
  #TODO: remove Memoist

  def error_message
    to_hash['error_message'] rescue super
  end
end