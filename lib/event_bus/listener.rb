# frozen_string_literal: true

require 'bunny'

module EventBus
  class Listener
    def self.on(event_name, &block)
      new.on(event_name, &block)
    end

    def on(event_name, &block)
      raise MissingAttributeError.new('Event name must be present') unless event_name&.size&.positive?

      EventBus::Config.broker.consume(event_name, &block)
    end
  end
end
