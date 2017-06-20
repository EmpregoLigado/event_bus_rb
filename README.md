# EventBus

[![CircleCI](https://circleci.com/gh/EmpregoLigado/event_bus_rb.svg?style=svg)](https://circleci.com/gh/EmpregoLigado/event_bus_rb)

![](http://assets.diylol.com/hfs/cc0/d52/de9/resized/short-bus-meme-generator-maddie-secondline-8cbf54.jpg)

EventBus provides additional messaging patterns for EmpregoLigado applications.
It exposes some methods for messaging-related features:
- EventBus::Emitter.trigger(event)
- EventBus::Listener.on(event_name)
- Extending EventBus::Listeners::Base

Let's look at a diagram for EventBus:

<p align='center'>
  <img src='https://cloud.githubusercontent.com/assets/10248067/11762943/5a927e54-a0bd-11e5-8aa5-e0fafae0e559.png' alt='EventsBus diagram'>
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'event_bus_rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install event_bus_rb

And set env vars:
```ruby
ENV['RABBIT_URL'] = 'amqp://guest:guest@localhost:5672'
ENV['RABBIT_EVENT_BUS_APP_NAME'] = 'EventBusExampleApp'
ENV['RABBIT_EVENT_BUS_VHOST'] = 'event_bus'
ENV['RABBIT_EVENT_BUS_TOPIC_NAME'] = 'event_bus'
````

## Usage

### Emitter
A application can trigger events based passing an EventBus::Event instance,
so others systems that listens to these events based matching the routing key (used as event_name below) will receive the event payload content.

```ruby
require 'event_bus_rb'

event_name = 'resource.origin.action'
body = { resource: 'full' }
event = EventBus::Event.new(event_name, body)

EventBus::Emitter.trigger(event)

EventBus::Config.broker.close_connection
```
[See more details](https://github.com/EmpregoLigado/event_bus_rb/blob/master/examples/emitter.rb)

### Listeners

An application that uses `EventBus` to handle _events_ should be treated as a
daemon like any other. The `Listener` api handles the blocking looping system,
so the client doesn`t need to think about those implementation details.

```ruby
require 'event_bus_rb'

event_name = 'resource.origin.action'

puts 'Start receiving messages'

EventBus::Listener.on(event_name) do |event|
  puts ""
  puts "  - Received a message from #{event.name}:"
  puts "     Message: #{event.body}"
  puts ""
end

puts  'Stop receiving messages'

EventBus::Config.broker.close_connection
```

[See more details](https://github.com/EmpregoLigado/event_bus_rb/blob/master/examples/listener.rb)

#### Multiple events routing

If your application needs to handle with loads of events you can extends ```EventBus::Listeners::Base``` and bind events to methods.

A simplistic example can be written like so:

```ruby
require 'event_bus_rb'

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
```
[See more details](https://github.com/EmpregoLigado/event_bus_rb/blob/master/examples/daemon.rb)

You can also bind more than one routing keys to methods using `*` or `#`.

Using `resource.*.pay`, for example, you can bind routing keys prefixed by **resource.** and suffixed by **.pay** to a method:

```
# bind resource.everything.pay to pay method
bind :pay, 'resource.*.pay'
```


Using `#`, you can bind all routing keys to a method:

```
# bind everything to receive method
bind :receive, '#'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

- Fork it
- Create your feature branch (`git checkout -b my-new-feature`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin my-new-feature`)
- Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
