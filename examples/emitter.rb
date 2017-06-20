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


events = []

event_name = 'resource.custom.pay'
body = { amount: 1500, name: 'John' }

events.push(EventBus::Event.new(event_name, body))

event_name = 'resource.custom.receive'
body = { amount: 300, name: 'George' }

events.push(EventBus::Event.new(event_name, body))

event_name = 'resource.origin.action'
body = { bo: 'dy' }
schemaVersion = 4.2

event = EventBus::Event.new(event_name, body, schemaVersion)

p 'Sending messsages.'

EventBus::Emitter.trigger(event)
EventBus::Emitter.trigger(events)

p 'Mesages sent!'

EventBus::Config.broker.close_connection
