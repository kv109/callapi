class Callapi::Call::Request::Api < Callapi::Call::Request::Http
  def host
    Callapi::Config.api_host || raise(Callapi::ApiHostNotSetError)
  end

  def uri
    @uri ||= super.tap do |uri|
      uri.path = api_path_prefix + request_path
    end
  end

  def api_path_prefix
    return Callapi::Config.api_path_prefix if Callapi::Config.api_path_prefix  # backward compatibility
    URI(Callapi::Config.api_host).path
  end
end