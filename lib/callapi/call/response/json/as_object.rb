require_relative '../../../../ext/deep_struct'

class Callapi::Call::Parser::Json::AsObject < Callapi::Call::Parser::Json
  def parse
    object.tap do |struct|
      append_data_excluded_from_parsing(struct)
    end
  end

  def self.keys_excluded_from_parsing
    @keys_excluded_from_parsing ||= []
  end

  def self.keys_excluded_from_parsing=(keys_excluded_from_parsing)
    @keys_excluded_from_parsing = keys_excluded_from_parsing
  end

  private

  def object
    if data_to_parse.is_a?(Array)
      data_to_parse.map { |item| DeepStruct.new(item) }
    else
      DeepStruct.new(data_to_parse)
    end
  end

  def data_to_parse
    keys_excluded_from_parsing = self.class.keys_excluded_from_parsing
    to_hash.dup.delete_if { |key, value| keys_excluded_from_parsing.include? key }
  end

  def data_excluded_from_parsing
    @data_excluded_from_parsing ||= {}.tap do |hash|
      self.class.keys_excluded_from_parsing.each do |key|
        hash[key] = to_hash[key]
      end
    end
  end

  def append_data_excluded_from_parsing(struct)
    return if struct.is_a?(Array)
    struct.tap do |struct|
      self.class.keys_excluded_from_parsing.each do |key|
        struct.send("#{key}=", data_excluded_from_parsing[key])
      end
    end
  end
end