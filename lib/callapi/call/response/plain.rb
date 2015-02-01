class Callapi::Call::Response::Plain < Callapi::Call::Response
  def parse
    body
  end
end