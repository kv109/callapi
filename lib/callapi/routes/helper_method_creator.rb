class Callapi::Routes::HelperMethodCreator
  POSTFIX = '_call'

  def initialize(call_class)
    @call_class = call_class
    @call_class_name = call_class.to_s
  end

  def create
    call_class = @call_class
    Object.send(:define_method, helper_method_name) do |*args|
      call_class.new(*args)
    end
  end

  def helper_method_base_name
    class_name = @call_class_name.dup
    class_name.scan(/(::)?((\w)+)Param/).map { |matched_groups| matched_groups[1] }.compact.each do |pattern|
      class_name.sub!(pattern, "By#{pattern}")
      class_name.sub!('Param', '')
    end
    class_name
  end

  def helper_method_name
    SuperString.underscore(helper_method_base_name).gsub('/', '_').gsub('callapi_', '') + POSTFIX
  end
end