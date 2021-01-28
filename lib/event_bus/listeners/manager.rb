# frozen_string_literal: true

# Module responsible for managing all listeners
module EventBus
  module Listeners
    module Manager
      class << self
        def bind_all_listeners
          listener_configurations.each do |config|
            EventBus::Listener.on(config[:routing_key]) do |event, channel, delivery_info|
              config[:listener_class].new(channel).send(config[:method], event, delivery_info)
            end
          end
        end

        def register_listener_configuration(configuration)
          listener_configurations.push(configuration)
        end

        private

        def listener_configurations
          @listener_configurations ||= []
        end
      end
    end
  end
end
