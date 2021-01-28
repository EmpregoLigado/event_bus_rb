# frozen_string_literal: true

module EventBus
  class Config
    APP_NAME = ENV['RABBIT_EVENT_BUS_APP_NAME']
    TOPIC    = ENV['RABBIT_EVENT_BUS_TOPIC_NAME']
    VHOST    = ENV['RABBIT_EVENT_BUS_VHOST']
    URL      = ENV['RABBIT_URL']
    FULL_URL = "#{ENV['RABBIT_URL']}/#{ENV['RABBIT_EVENT_BUS_VHOST']}"

    def self.broker
      EventBus::Broker::Rabbit
    end
  end
end
