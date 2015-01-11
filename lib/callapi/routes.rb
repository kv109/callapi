require 'active_support/core_ext/string'

class Callapi::Routes
  class << self
    def draw(&block)
      build_http_method_namespaces

      instance_eval &block
    end

    def get(*args)
      create_call_for_http_method(Callapi::Get, *args)
    end

    def post(*args)
      create_call_for_http_method(Callapi::Post, *args)
    end

    def put(*args)
      create_call_for_http_method(Callapi::Put, *args)
    end

    def delete(*args)
      create_call_for_http_method(Callapi::Delete, *args)
    end

    def patch(*args)
      create_call_for_http_method(Callapi::Patch, *args)
    end

    def namespace(*args)
      add_namespace(args.shift)
      yield
      remove_namespace
    end

    private

    def create_call_for_http_method(http_method_namespace, *args)
      @http_method_namespace = http_method_namespace
      @call_name, @call_options = args[0].camelize, args[1]
      @call_name_with_namespaces = namespaces.dup.push(@call_name)

      create_call_class
      create_helper_method
    end

    def create_call_class
      @call_name_with_namespaces.inject(@http_method_namespace) do |namespace, class_name|
        if namespace.constants.include?(class_name.to_sym)
          namespace.const_get(class_name)
        else
          namespace.const_set(class_name, Class.new(Callapi::Call::Base)).tap do |klass|
            @call_class = klass
            set_call_class_options if @call_options
            save_call_class
          end
        end
      end
    end

    def create_helper_method
      http_method = @http_method_namespace.to_s.split('::').last
      method_name = [http_method, @call_name_with_namespaces, 'call'].join('_').underscore
      call_class = @call_class
      Object.send(:define_method, method_name) do
        call_class
      end
    end

    def set_call_class_options
      @call_class.strategy = @call_options[:strategy] if @call_options[:strategy]
    end

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
      @build_http_method_namespaces ||= http_methods.each do |http_method|
        Callapi.const_set(http_method.to_s.camelize, Module.new)
      end
    end

    def http_methods
      Callapi::Call::Request::Http::HTTP_METHOD_TO_REQUEST_CLASS.keys
    end

    def call_classes
      @call_classes ||= []
    end

    def save_call_class
      call_classes << @call_class
    end
  end
end