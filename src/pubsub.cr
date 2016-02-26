require "./pubsub/*"

module Pubsub
  class EventBus
    @@bus = Hash(Symbol, Array( Proc( Tuple(String), NoReturn))).new

    def self.emit(event, payload : Tuple(String))
      procs = @@bus[event]
      procs.each do |pr|
        pr.call(payload)
      end
    end

    def self.listen(event, listener : Subscriber)
      listener_proc = ->(payload : Tuple(String)){
        listener.trigger(payload)
      }

      if @@bus.has_key?(event)
        @@bus[event] << listener_proc
      else
        @@bus[event] = [ listener_proc ]
      end
    end
  end

  module Subscriber
    abstract def trigger(payload : Tuple(String))
  end
end
