describe EventBus::Config do
  it 'has an app name config' do
    expect(EventBus::Config::APP_NAME).to eq 'app_name'
  end

  it 'has a topic config' do
    expect(EventBus::Config::TOPIC).to eq 'event_bus'
  end

  it 'has a vhost config' do
    expect(EventBus::Config::VHOST).to eq 'event_bus'
  end

  it 'has a host config' do
    expect(EventBus::Config::URL).to eq 'amqp://guest:guest@localhost:5672'
  end

  it 'has a full URL config' do
    expect(EventBus::Config::FULL_URL).to eq 'amqp://guest:guest@localhost:5672/event_bus'
  end

  it 'has a broker config' do
    expect(EventBus::Config.broker).to eq EventBus::Broker::Rabbit
  end
end
