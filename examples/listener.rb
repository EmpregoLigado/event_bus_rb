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


event_name = 'resource.origin.action'

puts 'Start receiving messages'

EventBus::Listener.on(event_name) do |event, _delivery_info|
  puts ''
  puts "  - Received a message from #{event.name}:"
  puts "     Message: #{event.body}"
  puts ''
end

puts  'Stop receiving messages'

EventBus::Config.broker.close_connection
