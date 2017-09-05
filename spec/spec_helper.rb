# Define all environment varibles for specs
ENV['RABBIT_EVENT_BUS_APP_NAME'] = "app_name"
ENV['RABBIT_EVENT_BUS_TOPIC_NAME'] = "event_bus"
ENV['RABBIT_EVENT_BUS_VHOST'] = "event_bus"
ENV['RABBIT_URL'] = "amqp://guest:guest@localhost:5672"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

Bundler.require(:default, 'test')

require 'rubygems'
require 'pry'

RSpec.configure do |config|
  config.order = :random

  config.expect_with(:rspec) do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with(:rspec) do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end
end
