describe EventBus::Emitter do
  let(:event) { EventBus::Event.new(name, body) }

  describe '.trigger' do
    before do
      allow(EventBus::Config.broker).to receive(:produce)
    end

    subject { described_class.trigger(event) }

    context 'when event is valid' do
      let(:body) { { amount: 300, name: 'George' } }
      let(:name) { 'name' }

      it 'produces the event on the broker' do
        expect(EventBus::Config.broker).to receive(:produce).with([event])

        subject
      end

      it 'does not raise an MissingAttributeError' do
        expect{subject}.not_to raise_error
      end
    end

    context 'when receives multiple events as parameters' do
      let(:event1) { EventBus::Event.new('name1', { amount: 200, name: 'Paul' }) }
      let(:event2) { EventBus::Event.new('name2', { amount: 400, name: 'Ringo' }) }
      let(:body) { { amount: 300, name: 'George' } }
      let(:name) { 'name' }

      subject { described_class.trigger(event, event1, event2) }

      it 'produces the events on the broker' do
        expect(EventBus::Config.broker).to receive(:produce).with([event, event1, event2])

        subject
      end

      it 'does not raise an MissingAttributeError' do
        expect{subject}.not_to raise_error
      end
    end

    context 'when receives an array of events' do
      let(:body) { { amount: 300, name: 'George' } }
      let(:name) { 'name' }
      let(:event1) { EventBus::Event.new('name1', { amount: 200, name: 'Paul' }) }
      let(:event2) { EventBus::Event.new('name2', { amount: 400, name: 'Ringo' }) }
      let(:events) { [event, event1, event2] }

      subject { described_class.trigger(events) }

      it 'produces the events on the broker' do
        expect(EventBus::Config.broker).to receive(:produce).with(events)

        subject
      end

      it 'does not raise an MissingAttributeError' do
        expect{subject}.not_to raise_error
      end
    end

    context 'when event body is not present' do
      let(:body) { nil }
      let(:name) { 'name' }

      it 'does not produce the event on the broker' do
        expect(EventBus::Config.broker).not_to receive(:produce)

        subject rescue nil
      end

      it 'raises an MissingAttributeError' do
        expect{subject}.to raise_error(EventBus::MissingAttributeError)
      end
    end

    context 'when event name is not present' do
      let(:body) { { amount: 300, name: 'George' } }
      let(:name) { nil }

      it 'does not produce the event on the broker' do
        expect(EventBus::Config.broker).not_to receive(:produce)

        subject rescue nil
      end

      it 'raises an MissingAttributeError' do
        expect{subject}.to raise_error(EventBus::MissingAttributeError)
      end
    end
  end
end
