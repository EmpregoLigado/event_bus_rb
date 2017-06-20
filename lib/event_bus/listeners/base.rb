module EventBus
  module Listeners
    class Base
      def self.bind(method, event_name)
        Manager.register_listener_configuration({
          listener_class: self,
          method: method,
          routing_key: event_name
        })
      end
    end
  end
end
