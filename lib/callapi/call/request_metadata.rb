require 'active_support/core_ext/string/inflections'

class Callapi::Call::RequestMetadata < Struct.new(:context)
  extend Memoist

  HTTP_METHODS = %w(GET POST PUT PATCH DELETE)

  def request_method
    http_method = namespace_with_http_method
    raise Callapi::UnknownHttpMethodError unless http_method
    http_method.downcase.to_sym
  end

  def request_path
    request_path = request_path_without_replaced_param_keys
    param_keys_to_replace.each do |param_key|
      param_value = context.params[param_key.to_sym] || raise(Callapi::MissingParamError.new(request_path, param_keys_to_replace, missing_keys))
      request_path.sub!(param_key + '_param', param_value.to_s)
    end
    request_path
  end
  memoize :request_path

  private

  def param_keys_to_replace
    request_path_without_replaced_param_keys.scan(/(\w+)_param/).map(&:first)
  end

  def request_path_without_replaced_param_keys
    '/' + call_name.underscore
  end
  memoize :request_path_without_replaced_param_keys

  def missing_keys
    (param_keys_to_replace.map(&:to_sym) - context.params.keys).map { |key| ":#{key}" }
  end

  def namespaces_after_http_method
    namespaces[namespaces.index(namespace_with_http_method) + 1 .. namespaces.size]
  end
  memoize :namespaces_after_http_method

  def namespace_with_http_method
    namespaces.detect{ |namespace| HTTP_METHODS.include?(namespace.upcase) } || raise(Callapi::UnknownHttpMethodError)
  end
  memoize :namespace_with_http_method

  def call_name
    namespaces_after_http_method.join('::')
  end

  def namespaces
    context.class.to_s.split('::')
  end
  memoize :namespaces
end