require 'ostruct'

class DeepStruct < OpenStruct
  def initialize(hash = nil)
    @table = {}
    @hash_table = {}

    if hash
      hash.each do |key, value|
        @table[key.to_sym] = process_value(value)
        @hash_table[key.to_sym] = value

        new_ostruct_member(key)
      end
    end
  end

  def process_value(value)
    if value.is_a?(Hash)
      self.class.new(value)
    elsif value.is_a?(Array)
      value.map { |element| process_value(element) }
    else
      value
    end
  end
end