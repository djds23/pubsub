require "./spec_helper"

class TestException < Exception
  def set_payload(@payload)
  end

  def payload
    @payload
  end
end

class TestSub
  include Pubsub::Subscriber
  def trigger(payload)
    error = TestException.new("We raise it!")
    error.set_payload(payload)
    raise error
  end
end

describe Pubsub do
  describe Pubsub::EventBus do
    describe "#emit" do
      it "fires a listener with a list" do
        Pubsub::EventBus.listen(:my_event, TestSub.new)
        expect_raises(TestException) do
          Pubsub::EventBus.emit(:my_event, [] of String)
        end
      end

      it "fires a listener with nil" do
        payload = ["a serialized object", "strings", "more_strings"]
        Pubsub::EventBus.listen(:my_event, TestSub.new)
        expect_raises(TestException) do
          begin
            Pubsub::EventBus.emit(:my_event, payload)
          rescue error : TestException
            error.payload.should eq(payload)
            raise error
          end
        end
      end
    end
  end
end

