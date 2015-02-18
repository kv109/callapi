class Callapi::Routes
  require_relative 'routes/metadata'
  require_relative 'routes/helper_method_creator'

  class << self
    def draw(&block)
      build_http_method_namespaces

      instance_eval &block

      create_classes
      create_helper_methods
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
            create_class(namespace, class_name, class_metadata).tap do |klass|
              created_call_classes << klass
            end
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
      end
    end

    def create_call_namespace(namespace, new_namespace)
      namespace.const_set(new_namespace, Class.new)
    end

    def create_helper_methods
      created_call_classes.each(&method(:create_helper_method))
    end

    def create_helper_method(klass)
      Callapi::Routes::HelperMethodCreator.new(klass).create
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
        camelized_http_method = SuperString.camelize(http_method.to_s)
        Callapi.const_set(camelized_http_method, Module.new)
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

    def created_call_classes
      @created_call_classes ||= []
    end
  end
end