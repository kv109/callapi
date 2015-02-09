class Callapi::Routes::Metadata
  extend Memoist

  def initialize(http_method_namespace, *args)
    @http_method_namespace = http_method_namespace
    @call_name, @call_options = args.shift, *args

    call_name_with_all_namespaces.size.times do |i|
      metadata = create_metadata(i)
      Callapi::Routes.send(:save_class, metadata) if metadata
    end
  end

  private

  def create_metadata(i)
    new_class_name = call_name_with_all_namespaces[i + 1]

    return unless new_class_name

    is_call_class = new_class_name.eql? call_name_with_all_namespaces.last

    OpenStruct.new.tap do |data|
      data.class_name = full_class_name(i)
      data.call_class = is_call_class
      data.http_method_namespace = @http_method_namespace
      data.http_method = @http_method_namespace.to_s.split('::').last
      if is_call_class
        data.class_options = @call_options
        data.call_name_with_namespaces = call_name_with_namespaces
      end
    end
  end

  def full_class_name(i)
    call_name_with_all_namespaces[0..i + 1].join('::')
  end

  def call_name_with_namespaces
    namespaces.push(@call_name).map do |class_name|
      if class_name_with_param_key?(class_name)
        class_name_to_class_name_with_param_key(class_name)
      else
        class_name
      end.camelize
    end
  end
  memoize :call_name_with_namespaces

  def call_name_with_all_namespaces
    [@http_method_namespace.to_s] + call_name_with_namespaces
  end
  memoize :call_name_with_all_namespaces

  def namespaces
    Callapi::Routes.send(:namespaces).dup
  end
  memoize :namespaces

  def class_name_with_param_key?(class_name)
    class_name[0] == ':' || class_name.match('/:')
  end

  def class_name_to_class_name_with_param_key(class_name)
    class_name.scan(/(:\w+)\/?/).map(&:first).each do |pattern|
      replacement = pattern.dup
      replacement[0] = ''
      replacement << '_param'
      class_name.sub!(pattern, replacement)
    end
    class_name
  end
end