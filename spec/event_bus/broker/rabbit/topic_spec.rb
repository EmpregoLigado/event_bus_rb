describe EventBus::Broker::Rabbit::Topic do
  let(:instance) { described_class.new(connection) }
  let(:connection) { OpenStruct.new(topic: topic) }
  let(:topic_options) { { durable: true, auto_delete: false } }
  let(:topic) { double('Topic') }
  let(:event) { EventBus::Event.new(routing_key, body) }
  let(:routing_key) { 'resource.origin.action' }
  let(:body) { { pay: 'load' } }
  let(:payload) { body.to_json }
  let(:schemaVersion) { 1.0 }

  before do
    allow(described_class).to receive(:new).with(connection).and_return(instance)
    allow(connection).to receive(:topic).with(EventBus::Config::TOPIC, topic_options).and_return(topic)
  end

  describe '.topic' do
    subject { described_class.topic(connection) }

    it 'creates an instance with given connection' do
      expect(described_class).to receive(:new).with(connection).and_return(instance)

      subject
    end

    it 'calls topic on instance' do
      expect(instance).to receive(:topic)

      subject
    end
  end

  describe '#topic' do
    subject { instance.topic }

    context 'when topic is not set up' do
      it 'creates a topic' do
        expect(connection).to receive(:topic).with(EventBus::Config::TOPIC, topic_options)

        subject
      end

      it 'returns topic' do
        expect(subject).to eq topic
      end
    end

    context 'when topic is already set up' do
      before do
        instance.topic
      end

      it 'does not create a topic' do
        expect(connection).not_to receive(:topic)

        subject
      end

      it 'returns topic' do
        expect(subject).to eq topic
      end
    end
  end

  describe '.produce' do
    let(:payload_expected) do
      header_specification = routing_key.split('.')
      {
        headers: {
          appName: EventBus::Config::APP_NAME,
          resource: header_specification[0],
          origin: header_specification[1],
          action: header_specification[2],
          schemaVersion: schemaVersion
        },
        body: body
      }.to_json
    end

    before do
      allow(topic).to receive(:publish).with(payload_expected,
                                             routing_key: routing_key,
                                             content_type: "application/json")
    end

    subject { described_class.produce(connection, event) }

    it 'creates an instance with given connection' do
      expect(described_class).to receive(:new).with(connection).and_return(instance)

      subject
    end

    it 'calls produce on instance' do
      expect(instance).to receive(:produce).with(event)

      subject
    end

    context 'with non defaut schemaVersion' do
      let(:schemaVersion) { 2.9 }
      let(:event) { EventBus::Event.new(routing_key, body, schemaVersion) }

      it 'changes schemaVersion default' do
        expect(topic).to receive(:publish).with(payload_expected,
                                                routing_key: routing_key,
                                                content_type: 'application/json')

        subject
      end
    end
  end

  describe '#produce' do
    let(:payload_expected) do
      header_specification = routing_key.split('.')
      {
        headers: {
          appName: EventBus::Config::APP_NAME,
          resource: header_specification[0],
          origin: header_specification[1],
          action: header_specification[2],
          schemaVersion: schemaVersion
        },
        body: body
      }.to_json
    end
    subject { instance.produce(event) }

    it 'publishes the event with correct params' do
      expect(topic).to receive(:publish).with(payload_expected,
                                              routing_key: routing_key,
                                              content_type: 'application/json')

      subject
    end
  end
end
