describe EventBus::Broker::Rabbit do
  let(:instance) { described_class.new }
  let(:channel) { 'channel' }

  before do
    allow(instance).to receive(:channel).and_return(channel)
  end

  describe '#connection' do
    let(:session) { 'session' }

    subject { instance.connection }

    after do
      described_class.class_variable_set('@@connection', nil)
    end

    context 'when not initialized' do
      before do
        allow(instance).to receive(:session).and_return(session)
      end
      
      it 'sets connection class var' do
        expect(described_class.class_variable_get('@@connection')).to be_nil

        subject

        expect(described_class.class_variable_get('@@connection')).to eq session
      end
    end

    context 'when already initialized' do
      let(:first_session) { 1 }

      before do
        allow(instance).to receive(:session).and_return(first_session)

        instance.connection

        allow(instance).to receive(:channel).and_return(session)
      end

      it 'does not update connection class var' do
        expect(described_class.class_variable_get('@@connection')).to eq first_session

        subject

        expect(described_class.class_variable_get('@@connection')).to eq first_session
      end
    end
  end

  describe '#consume' do
    let(:connection) { 'connection' }
    let(:event_name) { 'event_name' }
    let(:block) { ->(event) { true } }

    before do
      allow(instance).to receive(:connection).and_return(connection)
    end

    subject { instance.consume(event_name, &block) }

    it 'calls subscribe on Rabbit Queue class' do
      expect(EventBus::Broker::Rabbit::Queue).to receive(:subscribe).with(channel, event_name)

      subject
    end
  end

  describe '#produce' do
    let(:connection) { 'connection' }

    before do
      allow(instance).to receive(:connection).and_return(connection)
    end

    subject { instance.produce(events) }

    context 'when event is a single object' do
      let(:events) { ['event'] }

      it 'calls produce on Rabbit Topic class only once' do
        expect(EventBus::Broker::Rabbit::Topic).to receive(:produce).once

        subject
      end

      it 'calls produce on Rabbit Topic class' do
        expect(EventBus::Broker::Rabbit::Topic).to receive(:produce).with(channel, events.first)

        subject
      end
    end

    context 'when event is an array of events' do
      let(:events) { ['event1', 'event2', 'event3'] }

      subject { instance.produce(events) }

      it 'calls produce on Rabbit Topic class only once' do
        expect(EventBus::Broker::Rabbit::Topic).to receive(:produce).exactly(3).times

        subject
      end

      it 'calls produce on Rabbit Topic class' do
        events.each do |event|
          expect(EventBus::Broker::Rabbit::Topic).to receive(:produce).with(channel, event)
        end

        subject
      end
    end
  end
end
