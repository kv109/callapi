class Callapi::Call::RequestMetadata < Struct.new(:context)
  HTTP_METHODS = %w(GET POST PUT PATCH DELETE)

  def request_method
    http_method = namespace_with_http_method
    raise Callapi::UnknownHttpMethodError unless http_method
    http_method.downcase.to_sym
  end

  def request_path
    return @request_path if @request_path

    @request_path = request_path_without_replaced_param_keys
    param_keys_to_replace.each do |param_key|
      param_value = context.params[param_key.to_sym] || raise_missing_param_error
      @request_path.sub!(param_key + '_param', param_value.to_s)
    end
    @request_path
  end

  private

  def param_keys_to_replace
    request_path_without_replaced_param_keys.scan(/(\w+)_param/).map(&:first)
  end

  def request_path_without_replaced_param_keys
    @request_path_without_replaced_param_keys ||= "/#{SuperString.underscore(call_name)}"
  end

  def namespaces_after_http_method
    namespaces[namespaces.index(namespace_with_http_method) + 1 .. namespaces.size]
  end

  def namespace_with_http_method
    namespaces.detect{ |namespace| HTTP_METHODS.include?(namespace.upcase) } || raise(Callapi::UnknownHttpMethodError)
  end

  def call_name
    namespaces_after_http_method.join('::')
  end

  def namespaces
    @namespaces ||= context.class.to_s.split('::')
  end

  def raise_missing_param_error
    raise Callapi::MissingParamError.new(@request_path, param_keys_to_replace, missing_keys)
  end

  def missing_keys
    (param_keys_to_replace.map(&:to_sym) - context.params.keys).map { |key| ":#{key}" }
  end
end