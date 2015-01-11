require 'active_support/core_ext/string'

class Callapi::Routes
  require_relative 'routes/metadata'

  class << self
    def draw(&block)
      build_http_method_namespaces

      instance_eval &block

      create_namespace_classes
      create_call_classes
    end

    def get(*args)
      save_route(Callapi::Get, *args)
    end

    def post(*args)
      save_route(Callapi::Post, *args)
    end

    def put(*args)
      save_route(Callapi::Put, *args)
    end

    def delete(*args)
      save_route(Callapi::Delete, *args)
    end

    def patch(*args)
      save_route(Callapi::Patch, *args)
    end

    def namespace(*args)
      add_namespace(args.shift)
      yield
      remove_namespace
    end

    private

    def save_route(http_method_namespace, *args)
      Callapi::Routes::Metadata.new(http_method_namespace, *args)
    end

    def create_namespace_classes
      namespace_classes.each(&method(:create_namespace_class))
    end

    def create_call_classes
      call_classes.each(&method(:create_call_class))
    end

    def create_namespace_class(class_metadata)
      classes = class_metadata.class_name.split('::')
      classes = classes[2..classes.size]

      classes.inject(class_metadata.http_method_namespace) do |namespace, class_name|
        namespace.const_set(class_name, Class.new)
      end
    end

    def create_call_class(class_metadata)
      classes = class_metadata.class_name.split('::')
      class_name = classes.pop
      namespace = classes.join('::').constantize

      namespace.const_set(class_name, Class.new(Callapi::Call::Base)).tap do |klass|
        set_call_class_options(klass, class_metadata.class_options) if class_metadata.class_options
        create_helper_method(klass, class_metadata)
      end
    end

    def create_helper_method(klass, class_metadata)
      http_method = class_metadata.http_method_namespace.to_s.split('::').last
      method_name = [http_method, class_metadata.call_name_with_namespaces, 'call'].join('_').underscore
      Object.send(:define_method, method_name) do
        klass
      end
    end

    def set_call_class_options(klass, options)
      klass.strategy = options[:strategy] if options[:strategy]
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

    def classes
      @classes ||= []
    end

    def save_class(class_data)
      classes << class_data unless classes.include?(class_data)
    end

    def call_classes
      classes.select(&:call_class)
    end

    def namespace_classes
      classes - call_classes
    end

    def clear
      @classes = []
    end
  end
end