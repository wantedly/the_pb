RSpec.describe Pb do
  describe "VERSION" do
    it "has a version number" do
      expect(Pb::VERSION).not_to be nil
    end
  end

  describe ".to_proto" do
    context "when klass is Timestamp" do
      context "when value is Time" do
        it "returns protobuf object" do
          expect(Pb.to_proto(Google::Protobuf::Timestamp, nil)).to eq nil

          expect(
            Pb.to_proto(Google::Protobuf::Timestamp, Time.new(2019, 3, 1, 16, 30))
          ).to eq Google::Protobuf::Timestamp.new(seconds: Time.new(2019, 3, 1, 16, 30).to_i)
        end
      end

      context "when value is DateTime" do
        it "returns protobuf object" do
          expect(
            Pb.to_proto(Google::Protobuf::Timestamp, DateTime.new(2019, 3, 1, 7, 30))  # UTC
          ).to eq Google::Protobuf::Timestamp.new(seconds: Time.new(2019, 3, 1, 16, 30).to_i)  # JST
        end
      end

      context "when value is Date" do
        it "returns protobuf object" do
          expect(
            Pb.to_proto(Google::Protobuf::Timestamp, Date.new(2019, 3, 1))
          ).to eq Google::Protobuf::Timestamp.new(seconds: Time.new(2019, 3, 1).to_i)
        end
      end

      context "when value is String" do
        it "returns protobuf object" do
          expect(Pb.to_proto(Google::Protobuf::Timestamp, "2019-03-01T00:00:00+09:00"))
            .to eq Google::Protobuf::Timestamp.new(seconds: Time.new(2019, 3, 1).to_i)
        end
      end
    end

    context "when klass is StringValue" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::StringValue, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::StringValue, "Taro"))
          .to eq Google::Protobuf::StringValue.new(value: "Taro")
      end
    end

    context "when klass is Int32Value" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::Int32Value, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::Int32Value, 33))
          .to eq Google::Protobuf::Int32Value.new(value: 33)
      end
    end

    context "when klass is Int64Value" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::Int64Value, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::Int64Value, "33"))
          .to eq Google::Protobuf::Int64Value.new(value: 33)

        expect(Pb.to_proto(Google::Protobuf::Int64Value, 33))
          .to eq Google::Protobuf::Int64Value.new(value: 33)
      end
    end

    context "when klass is UInt32Value" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::UInt32Value, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::UInt32Value, 33))
          .to eq Google::Protobuf::UInt32Value.new(value: 33)
      end
    end

    context "when klass is UInt64Value" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::UInt64Value, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::Int64Value, "33"))
          .to eq Google::Protobuf::Int64Value.new(value: 33)

        expect(Pb.to_proto(Google::Protobuf::UInt64Value, 33))
          .to eq Google::Protobuf::UInt64Value.new(value: 33)
      end
    end

    context "when klass is FloatValue" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::FloatValue, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::FloatValue, 3.0))
          .to eq Google::Protobuf::FloatValue.new(value: 3.0)
      end
    end

    context "when klass is DoubleValue" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::DoubleValue, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::DoubleValue, 3.0))
          .to eq Google::Protobuf::DoubleValue.new(value: 3.0)
      end
    end

    context "when klass is BoolValue" do
      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::BoolValue, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::BoolValue, true))
          .to eq Google::Protobuf::BoolValue.new(value: true)
      end
    end

    context "when klass is BytesValue" do
      let(:bytes) { "\x0\x1".encode(Encoding::ASCII_8BIT) }

      it "returns protobuf object" do
        expect(Pb.to_proto(Google::Protobuf::BytesValue, nil)).to eq nil

        expect(Pb.to_proto(Google::Protobuf::BytesValue, bytes))
          .to eq Google::Protobuf::BytesValue.new(value: bytes)
      end
    end

    context "when value is an instance of a builtin type" do
      context "when klass is Timestamp" do
        let(:klass) { Google::Protobuf::Timestamp }
        let(:value) { klass.new(seconds: 1) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is StringValue" do
        let(:klass) { Google::Protobuf::StringValue }
        let(:value) { klass.new(value: "string") }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is Int32Value" do
        let(:klass) { Google::Protobuf::Int32Value }
        let(:value) { klass.new(value: 1) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is Int64Value" do
        let(:klass) { Google::Protobuf::Int64Value }
        let(:value) { klass.new(value: 1) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is UInt32Value" do
        let(:klass) { Google::Protobuf::UInt32Value }
        let(:value) { klass.new(value: 1) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is UInt64Value" do
        let(:klass) { Google::Protobuf::UInt64Value }
        let(:value) { klass.new(value: 1) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is FloatValue" do
        let(:klass) { Google::Protobuf::FloatValue }
        let(:value) { klass.new(value: 1.0) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is DoubleValue" do
        let(:klass) { Google::Protobuf::DoubleValue }
        let(:value) { klass.new(value: 1.0) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is BoolValue" do
        let(:klass) { Google::Protobuf::BoolValue }
        let(:value) { klass.new(value: true) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end

      context "when klass is BytesValue" do
        let(:klass) { Google::Protobuf::BytesValue }
        let(:value) { klass.new(value: "\x0\x1".encode(Encoding::ASCII_8BIT)) }

        it "returns protobuf object" do
          expect(Pb.to_proto(klass, value)).to eq value
        end
      end
    end

    context "when value is not builtin type" do
      let(:proto_class_a) {
        klass_b = proto_class_b  # Assign to variable

        # Use random name to avoid conflict
        proto_class_name = "proto_class_a_#{Array.new(20) { rand(('a'.ord)..('z'.ord)).chr }.join}"

        Google::Protobuf::DescriptorPool.generated_pool.build do
          add_message proto_class_name do
            optional :id, :int64, 1
            optional :name, :message, 2, "google.protobuf.StringValue"
            optional :created_at, :message, 3, "google.protobuf.Timestamp"
            optional :proto_b, :message, 4, klass_b.descriptor.name
          end
        end

        Google::Protobuf::DescriptorPool.generated_pool.lookup(proto_class_name).msgclass
      }
      let(:proto_class_b) {
        # Use random name to avoid conflict
        proto_class_name = "proto_class_b_#{Array.new(20) { rand(('a'.ord)..('z'.ord)).chr }.join}"

        Google::Protobuf::DescriptorPool.generated_pool.build do
          add_message proto_class_name do
            optional :id, :int64, 1
          end
        end

        Google::Protobuf::DescriptorPool.generated_pool.lookup(proto_class_name).msgclass
      }

      it "returns proto object" do
        expect(Pb.to_proto(proto_class_a, {})).to eq proto_class_a.new

        expect(Pb.to_proto(proto_class_a, {
          id:         0,
          name:       nil,
          created_at: nil,
          proto_b:    nil,
        })).to eq proto_class_a.new(
          id:         0,
          name:       nil,
          created_at: nil,
          proto_b:    nil,
        )

        expect(Pb.to_proto(proto_class_a, {
          id:         1,
          name:       "Taro Sato",
          created_at: "2019-02-03T00:00:00+09:00",
          proto_b:    {
            id: 2,
          }
        })).to eq proto_class_a.new(
          id:   1,
          name: Google::Protobuf::StringValue.new(value: "Taro Sato"),
          created_at: Google::Protobuf::Timestamp.new(seconds: Time.new(2019, 2, 3).to_i),
          proto_b: proto_class_b.new(
            id: 2,
          )
        )

        expect(Pb.to_proto(proto_class_a, {
          "id"         => "1",
          "name"       => "Taro Sato",
          "created_at" => "2019-02-03T00:00:00+09:00",
          "proto_b"    => {
            "id" => "2"
          }
        })).to eq proto_class_a.new(
          id:   1,
          name: Google::Protobuf::StringValue.new(value: "Taro Sato"),
          created_at: Google::Protobuf::Timestamp.new(seconds: Time.new(2019, 2, 3).to_i),
          proto_b: proto_class_b.new(
            id: 2,
          )
        )
      end
    end
  end
end
