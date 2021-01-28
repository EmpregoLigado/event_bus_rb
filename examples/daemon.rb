#!/usr/bin/env ruby
# frozen_string_literal: true

ENV['RABBIT_URL'] = 'amqp://guest:guest@localhost:5672'
ENV['RABBIT_EVENT_BUS_APP_NAME'] = 'EventBusExampleApp'
ENV['RABBIT_EVENT_BUS_VHOST'] = 'event_bus'
ENV['RABBIT_EVENT_BUS_TOPIC_NAME'] = 'event_bus'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rubygems'
require 'bundler'
Bundler.require(:default, 'development')

require 'event_bus'


class CustomEventListener < EventBus::Listeners::Base
  bind :pay, 'resource.custom.pay'
  bind :receive, 'resource.custom.receive'

  def pay(event, delivery_info)
    puts "Paid #{event.body['amount']} for #{event.body['name']} ~> #{event.name}"

    channel.acknowledge(delivery_info.delivery_tag, false)
  end

  def receive(event, delivery_info)
    if event.body['amount'] > 42
      channel.acknowledge(delivery_info.delivery_tag, false)
      puts "Received #{event.body['amount']} from #{event.body['name']} ~> #{event.name}"
    else
      puts '[consumer] Got SKIPPED message'
    end
  end
end

puts '****************** Daemon Ready ******************'

EventBus::Daemon.start
