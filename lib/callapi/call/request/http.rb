require 'net/http'
require 'addressable/uri'

class Callapi::Call::Request::Http < Callapi::Call::Request::Base
  require_relative 'http/log_helper'

  extend Memoist
  include Callapi::Call::Request::Http::LogHelper

  HTTP_METHOD_TO_REQUEST_CLASS = {
    get: Net::HTTP::Get
  }

  def response
    with_logging do
      http.request(request)
    end
  end

  private

  def host
    raise NotImplementedError
  end

  def http
    Net::HTTP.new(uri.host, uri.port)
  end

  def request
    request_class.new(uri.request_uri, headers)
  end

  def request_class
    HTTP_METHOD_TO_REQUEST_CLASS[request_method] || raise(Callapi::Call::Errors::UnknownHttpMethod)
  end

  def uri
    Addressable::URI.parse(host).tap do |uri|
      uri.path = path_prefix + request_path
      uri.query_values = params
    end
  end
  memoize :uri

  def path_prefix
    ''
  end
end