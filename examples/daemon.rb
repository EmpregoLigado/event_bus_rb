#!/usr/bin/env ruby

ENV['RABBIT_URL'] = 'amqp://guest:guest@localhost:5672'
ENV['RABBIT_EVENT_BUS_APP_NAME'] = 'EventBusExampleApp'
ENV['RABBIT_EVENT_BUS_VHOST'] = 'event_bus'
ENV['RABBIT_EVENT_BUS_TOPIC_NAME'] = 'event_bus'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'bundler'
Bundler.require(:default, 'development')

require 'event_bus'


class CustomEventListener < EventBus::Listeners::Base
  bind :pay, 'resource.custom.pay'
  bind :receive, 'resource.custom.receive'

  def pay(event)
    puts "Paid #{event.body['amount']} for #{event.body['name']} ~> #{event.name}"
  end

  def receive(event)
    puts "Received #{event.body['amount']} from #{event.body['name']} ~> #{event.name}"
  end
end

puts "****************** Daemon Ready ******************"

EventBus::Daemon.start
