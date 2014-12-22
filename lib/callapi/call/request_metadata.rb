require 'active_support/core_ext/string/inflections'

class Callapi::Call::RequestMetadata < Struct.new(:context)
  extend Memoist

  HTTP_METHODS = %w(GET POST PUT PATCH DELETE)

  def request_method
    http_method = namespace_with_http_method
    raise Call::Errors::UnknownHttpMethod unless http_method
    http_method.downcase.to_sym
  end

  def request_path
    absolutized_call_name
  end

  private

  def namespaces_after_http_method
    namespaces[namespaces.index(namespace_with_http_method) + 1 .. namespaces.size]
  end
  memoize :namespaces_after_http_method

  def namespace_with_http_method
    namespaces.detect{ |namespace| HTTP_METHODS.include?(namespace.upcase) } || raise(Callapi::Call::Errors::UnknownHttpMethod)
  end
  memoize :namespace_with_http_method

  def call_name
    namespaces_after_http_method.join('::')
  end

  def absolutized_call_name
    '/' << call_name.underscore
  end

  def namespaces
    context.class.to_s.split('::')
  end
  memoize :namespaces
end