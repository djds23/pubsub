require "./spec_helper"

class TestException < Exception
end

class TestSub
  include Pubsub::Subscriber
  def trigger(payload)
    raise TestException.new("We raise it!")
  end
end

describe Pubsub do
  describe Pubsub::EventBus do
    describe "#emit" do
      it "fires a listener" do
        Pubsub::EventBus.listen(:my_event, TestSub.new)
        begin
          Pubsub::EventBus.emit(:my_event, {"This is an object!"})
        rescue e
          e.should be_a TestException
        end
      end
    end
  end
end

