module EventBus
  module Broker
    class Rabbit::Topic
      def initialize(connection)
        @channel = connection
      end

      def self.topic(connection)
        new(connection).topic
      end

      def topic
        @topic ||= channel.topic(EventBus::Config::TOPIC, topic_options)
      end

      def self.produce(connection, event)
        new(connection).produce(event)
      end

      def produce(event)
        topic.publish(event.payload, routing_key: event.name)
      end

      private

      attr_reader :channel

      def topic_options
        { durable: true, auto_delete: false }
      end
    end
  end
end
