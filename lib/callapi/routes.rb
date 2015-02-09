require 'active_support/core_ext/string'

class Callapi::Routes
  require_relative 'routes/metadata'

  class << self
    def draw(&block)
      build_http_method_namespaces

      instance_eval &block

      create_classes
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

    def create_classes
      classes_metadata.each do |class_metadata|
        classes = classes_without_http_namespace(class_metadata)

        classes.inject(class_metadata.http_method_namespace) do |namespace, class_name|
          if namespace.constants.include?(class_name.to_sym)
            namespace.const_get(class_name)
          else
            create_class(namespace, class_name, class_metadata)
          end
        end
      end
    end

    def classes_without_http_namespace(class_metadata)
      classes = class_metadata.class_name.split('::')
      classes[2..classes.size]
    end

    def create_class(namespace, class_name, class_metadata)
      full_class_name = "#{namespace}::#{class_name}"
      if call_classes_names.include?(full_class_name)
        create_call_class(namespace, class_name, class_metadata)
      else
        create_call_namespace(namespace, class_name)
      end
    end

    def create_call_class(namespace, class_name, class_metadata)
      namespace.const_set(class_name, Class.new(Callapi::Call::Base)).tap do |klass|
        set_call_class_options(klass, class_metadata.class_options) if class_metadata.class_options
        create_helper_method(klass, class_metadata)
      end
    end

    def create_call_namespace(namespace, new_namespace)
      namespace.const_set(new_namespace, Class.new)
    end

    def create_helper_method(klass, class_metadata)
      http_method = class_metadata.http_method_namespace.to_s.split('::').last
      call_name_with_namespaces = class_metadata.call_name_with_namespaces.map do |class_name|
        class_name.scan(/(::)?((\w)+)Param/).map { |matched_groups| matched_groups[1] }.compact.each do |pattern|
          class_name.sub!(pattern, "By#{pattern}")
          class_name.sub!('Param', '')
        end
        class_name
      end
      method_name = [http_method, call_name_with_namespaces, 'call'].join('_')
      method_name = method_name.underscore.gsub('/', '_')
      Object.send(:define_method, method_name) do |*args|
        klass.new(*args)
      end
    end

    def set_call_class_options(klass, options)
      klass.strategy = options[:strategy] if options[:strategy]
      klass.response_parser = options[:parser] if options[:parser]
    end

    def namespaces
      @namespaces ||= []
    end

    def add_namespace(namespace)
      namespaces << namespace.to_s
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

    def save_class(class_metadata)
      classes_metadata << class_metadata unless classes_metadata.include?(class_metadata)
      @call_classes = nil
      @call_classes_names = nil
    end

    def classes_metadata
      @classes_metadata ||= []
    end

    def call_classes_metadata
      @call_classes ||= classes_metadata.select(&:call_class)
    end

    def call_classes_names
      @call_classes_names ||= call_classes_metadata.map(&:class_name).uniq
    end
  end
end