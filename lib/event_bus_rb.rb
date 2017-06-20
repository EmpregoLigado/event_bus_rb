require 'dotenv'

root = Dir.pwd
Dotenv.load("#{root}/.env.local", "#{root}/.env.#{ENV['RACK_ENV']}", "#{root}/.env")

require 'event_bus/version'
require 'event_bus/daemon'
require 'event_bus/event'
require 'event_bus/config'
require 'event_bus/emitter'
require 'event_bus/listener'
require 'event_bus/listeners/base'
require 'event_bus/listeners/manager'
require 'event_bus/broker/base'
require 'event_bus/broker/rabbit'
require 'event_bus/broker/rabbit/queue'
require 'event_bus/broker/rabbit/topic'

module EventBus
  class MissingAttributeError < StandardError; end
end
