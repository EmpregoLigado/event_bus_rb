# frozen_string_literal: true

module EventBus
  module Broker
    class Base
      @@connection = nil

      def self.consumers
        @consumers ||= {}
      end

      def connection
        raise NotImplementedError.new('Must be implemented')
      end

      def self.close_connection
        raise NotImplementedError.new('Must be implemented')
      end

      def self.consume(event_name, &block)
        consumers[event_name] ||= begin
          new.consume(event_name, &block)
        end
      end

      def consume(event_name, &block)
        raise NotImplementedError.new('Must be implemented')
      end

      def self.produce(events)
        new.produce(events)
      end

      def produce(events)
        raise NotImplementedError.new('Must be implemented')
      end
    end
  end
end
