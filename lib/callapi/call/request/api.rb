class Callapi::Call::Request::Api < Callapi::Call::Request::Http
  def host
    Callapi::Config.api_host || raise(Callapi::ApiHostNotSetError)
  end

  def path_prefix
    Callapi::Config.default_path_prefix
  end
end