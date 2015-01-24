require_relative '../../../../ext/deep_struct'

class Callapi::Call::Response::Json::AsObject < Callapi::Call::Response::Json
  extend Memoist

  def to_struct
    hash_to_struct.tap do |struct|
      append_data_excluded_from_parsing(struct)
    end
  end

  private

  def hash_to_struct
    if data_to_parse.is_a?(Array)
      data_to_parse.map { |item| DeepStruct.new(item) }
    else
      DeepStruct.new(data_to_parse)
    end
  end

  def data_to_parse
    to_hash.dup.tap do |hash|
      keys_excluded_from_parsing.each { |key| hash.delete(key) }
    end
  end

  def data_excluded_from_parsing
    {}.tap do |hash|
      keys_excluded_from_parsing.each do |key|
        hash[key] = to_hash[key]
      end
    end
  end
  memoize :data_excluded_from_parsing

  def append_data_excluded_from_parsing(struct)
    return if struct.is_a?(Array)
    struct.tap do |struct|
      keys_excluded_from_parsing.each do |key|
        struct.send("#{key}=", data_excluded_from_parsing[key])
      end
    end
  end

  #TODO: should be configurable
  def keys_excluded_from_parsing
    %w(translations)
  end
end