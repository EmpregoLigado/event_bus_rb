# frozen_string_literal: true

require 'json'

module EventBus
  # Public: An class which decorates el-rabbit topic creation.
  #
  class Emitter
    # Public: Produces a event on the Broker.
    #
    # event - The event to be produced.
    #
    # Returns the Event.
    def self.trigger(*events)
      events.flatten.each_with_index do |event, index|
        raise MissingAttributeError.new("Event on position #{index} must have a body") unless event.has_body?
        raise MissingAttributeError.new("Event on position #{index} must have a name") unless event.has_name?
      end

      EventBus::Config.broker.produce(events.flatten)

      events
    end
  end
end
