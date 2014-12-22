class Callapi::Call::Request::Api < Callapi::Call::Request::Http
  def host
    Callapi::Config.api_host || raise(Callapi::Call::Errors::ApiHostNotSet)
  end

  def path_prefix
    Callapi::Config.default_path_prefix
  end
end