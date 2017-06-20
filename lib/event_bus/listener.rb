require 'bunny'

module EventBus
  class Listener
    def self.on(event_name, &block)
      new.on(event_name, &block)
    end

    def on(event_name, &block)
      raise MissingAttributeError.new('Event name must be present') unless event_name && event_name.size > 0

      EventBus::Config.broker.consume(event_name, &block)
    end
  end
end
