require "date"
require "time"
require "google/protobuf"
require "google/protobuf/timestamp_pb"
require "google/protobuf/wrappers_pb"

require "pb/version"

module Pb
  BUILTIN_PROTO_TYPES = [
    Google::Protobuf::Timestamp,
    Google::Protobuf::StringValue,
    Google::Protobuf::Int32Value,
    Google::Protobuf::Int64Value,
    Google::Protobuf::UInt32Value,
    Google::Protobuf::UInt64Value,
    Google::Protobuf::FloatValue,
    Google::Protobuf::DoubleValue,
    Google::Protobuf::BoolValue,
    Google::Protobuf::BytesValue,
  ].freeze

  class << self
    # @param [Time, DateTime, Date, String, nil] t
    # @return [Google::Protobuf::Timestamp, nil]
    def to_timestamp(t)
      return nil if t.nil?
      return t if t.is_a?(Google::Protobuf::Timestamp)
      case t
      when DateTime, Date
        t = t.to_time
      when String
        t = Time.parse(t)
      else
        # Do nothing
      end
      Google::Protobuf::Timestamp.new(seconds: t.to_i, nanos: t.nsec)
    end

    # @param [String, nil]
    # @return [Google::Protobuf::StringValue, nil]
    def to_strval(str)
      return nil if str.nil?
      return str if str.is_a?(Google::Protobuf::StringValue)
      Google::Protobuf::StringValue.new(value: str)
    end

    # @param [Integer, nil] num
    # @return [Google::Protobuf::Int32Value, nil]
    def to_int32val(num)
      return nil if num.nil?
      return num if num.is_a?(Google::Protobuf::Int32Value)
      Google::Protobuf::Int32Value.new(value: num)
    end

    # @param [String, Integer, nil] num
    # @return [Google::Protobuf::Int64Value, nil]
    def to_int64val(num)
      return nil if num.nil?
      return num if num.is_a?(Google::Protobuf::Int64Value)
      case num
      when String
        n = num.to_i
      else # Integer
        n = num
      end
      Google::Protobuf::Int64Value.new(value: n)
    end

    # @param [Integer, nil] num
    # @return [Google::Protobuf::UInt32Value, nil]
    def to_uint32val(num)
      return nil if num.nil?
      return num if num.is_a?(Google::Protobuf::UInt32Value)
      Google::Protobuf::UInt32Value.new(value: num)
    end

    # @param [String, Integer, nil] num
    # @return [Google::Protobuf::UInt64Value, nil]
    def to_uint64val(num)
      return nil if num.nil?
      return num if num.is_a?(Google::Protobuf::UInt64Value)
      case num
      when String
        n = num.to_i
      else # Integer
        n = num
      end
      Google::Protobuf::UInt64Value.new(value: n)
    end

    # @param [Float, nil] num
    # @return [Google::Protobuf::FloatValue, nil]
    def to_floatval(num)
      return nil if num.nil?
      return num if num.is_a?(Google::Protobuf::FloatValue)
      Google::Protobuf::FloatValue.new(value: num)
    end

    # @param [Float, nil] num
    # @return [Google::Protobuf::DoubleValue, nil]
    def to_doubleval(num)
      return nil if num.nil?
      return num if num.is_a?(Google::Protobuf::DoubleValue)
      Google::Protobuf::DoubleValue.new(value: num)
    end

    # @param [bool, nil] b
    # @return [Google::Protobuf::BoolValue, nil]
    def to_boolval(b)
      return nil if b.nil?
      return b if b.is_a?(Google::Protobuf::BoolValue)
      Google::Protobuf::BoolValue.new(value: b)
    end

    # @param [String, nil] bytes
    # @return [Google::Protobuf::BytesValue, nil]
    def to_bytesval(bytes)
      return nil if bytes.nil?
      return bytes if bytes.is_a?(Google::Protobuf::BytesValue)
      Google::Protobuf::BytesValue.new(value: bytes)
    end

    # @param [Class] klass Protobuf message class
    # @param [Object, nil] v
    # @return [Object, nil] Protobuf message object.
    def to_builtin_proto(klass, v)
      return nil if v.nil?

      if klass == Google::Protobuf::Timestamp
        to_timestamp(v)
      elsif klass == Google::Protobuf::StringValue
        to_strval(v)
      elsif klass == Google::Protobuf::Int32Value
        to_int32val(v)
      elsif klass == Google::Protobuf::Int64Value
        to_int64val(v)
      elsif klass == Google::Protobuf::UInt32Value
        to_uint32val(v)
      elsif klass == Google::Protobuf::UInt64Value
        to_uint64val(v)
      elsif klass == Google::Protobuf::FloatValue
        to_floatval(v)
      elsif klass == Google::Protobuf::DoubleValue
        to_doubleval(v)
      elsif klass == Google::Protobuf::BoolValue
        to_boolval(v)
      elsif klass == Google::Protobuf::BytesValue
        to_bytesval(v)
      else
        raise "Invalid klass: #{klass} is not included in supported classes (#{BUILTIN_PROTO_TYPES})"
      end
    end

    # @param [Class] klass A Protobuf message class
    # @param [Hash, Array<Hash>, nil] v A Hash object or An Array of Hash objects. Hash
    # objects contain parameters of a Protobuf message object
    # @return [Object, Array<Object>, nil] A Protobuf message object
    def to_proto(klass, v)
      case v
      when Array
        v.map { |e| to_proto_one(klass, e) }
      else
        to_proto_one(klass, v)
      end
    end

    # @param [Symbol] type The type of protobuf field. e.g. :enum, :int64,
    #   :string, :int32, :bool, etc.
    # @param [Object] v
    # @return [Object]
    def to_primitive(type, v)
      case v
      when Array
        v.map { |e| to_primitive_one(type, e) }
      else
        to_primitive_one(type, v)
      end
    end

  private

    class TypeInfo
      # @param [Symbol] type The type of protobuf field. e.g. :enum, :int64,
      #   :string, :int32, :bool, :message, etc.
      # @param [Google::Protobuf::Descriptor, nil] subtype
      def initialize(type:, subtype:)
        @type    = type
        @subtype = subtype
      end
      attr_reader :type, :subtype
    end

    # @param [Class] klass A Protobuf message class
    # @param [Hash, nil] v A Hash object which contains parameters of a Protobuf
    # message object
    # @return [Object, nil] A Protobuf message object
    def to_proto_one(klass, v)
      if BUILTIN_PROTO_TYPES.include?(klass)
        return to_builtin_proto(klass, v)
      end

      return nil if v.nil?

      field_types = {}  # Hash{String => TypeInfo}
      klass.descriptor.entries.each do |e|
        field_types[e.name.to_s] = TypeInfo.new(type: e.type, subtype: e.subtype)
      end

      params = {}
      v.each do |k, vv|
        type_info = field_types[k.to_s]
        next if type_info.nil?  # Ignore unknown field

        if type_info.type == :message
          params[k] = to_proto(type_info.subtype.msgclass, vv)
        else
          params[k] = to_primitive(type_info.type, vv)
        end
      end
      klass.new(params)
    end

    # @param [Symbol] type The type of protobuf field. e.g. :enum, :int64,
    #   :string, :int32, :bool, etc.
    # @param [Object] v
    # @return [Object]
    def to_primitive_one(type, v)
      case type
      when :int64, :uint64
        v.to_i  # Convert string to int if necessary
      else
        v
      end
    end
  end
end
