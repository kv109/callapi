require 'active_support/core_ext/string'

class Callapi::Routes
  class << self
    def draw(&block)
      build_http_method_namespaces

      instance_eval &block
    end

    def get(*args)
      call_name = args.shift
      camelized_call_name = call_name.camelize
      camelized_call_name_with_namespaces = namespaces + [camelized_call_name]
      camelized_call_name_with_namespaces.inject(Get) do |k, class_name|
        k.const_set(class_name, Class.new(Callapi::Call::Base))
      end
    end

    def namespace(*args)
      add_namespace(args.shift)
      yield
      remove_namespace
    end

    private

    def namespaces
      @namespaces ||= []
    end

    def add_namespace(namespace)
      namespaces << namespace.to_s.camelize
    end

    def remove_namespace
      namespaces.pop
    end

    def build_http_method_namespaces
      Callapi::Call::Request::Http::HTTP_METHOD_TO_REQUEST_CLASS.keys.each do |http_method|
        Object.const_set(http_method.to_s.camelize, Module.new)
      end
    end
  end
end