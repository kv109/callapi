class Callapi::Call::Response::Plain < Callapi::Call::Response
  def to_struct
    body
  end
end