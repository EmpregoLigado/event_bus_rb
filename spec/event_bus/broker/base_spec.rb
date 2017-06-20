describe EventBus::Broker::Base do
  describe '.consume' do
    let(:event_name) { 'event_name' }
    let(:block) { ->(event) { true } }
    let(:result) { {} }

    before do
      allow_any_instance_of(described_class).to receive(:consume).and_return(result)
    end

    subject { described_class.consume(event_name, &block) }

    after do
      described_class.remove_instance_variable(:@consumers) if described_class.instance_variable_get(:@consumers)
    end

    context 'when consuming new event' do
      it 'adds listener to the consumers list' do
        expect(described_class.consumers[event_name]).to be_nil

        subject

        expect(described_class.consumers[event_name]).to eq(result)
      end

      it 'creates an instace' do
        expect(described_class).to receive(:new).and_call_original

        subject
      end

      it 'calls consume on instance with correct parameters' do
        expect_any_instance_of(described_class).to receive(:consume).with(event_name)

        subject
      end
    end

    context 'when consuming duplicated event' do
      let(:first_result) { '1' }

      before do
        allow_any_instance_of(described_class).to receive(:consume).and_return(first_result)

        described_class.consume(event_name, &block)

        allow_any_instance_of(described_class).to receive(:consume).and_return(result)
      end

      it 'adds listener to the consumers list' do
        expect(described_class.consumers[event_name]).to eq(first_result)

        subject

        expect(described_class.consumers[event_name]).to eq(first_result)
      end

      it 'does not create an instace' do
        expect(described_class).not_to receive(:new)

        subject
      end

      it 'does not call consume on instance with correct parameters' do
        expect_any_instance_of(described_class).not_to receive(:consume)

        subject
      end
    end
  end

  describe '.produce' do
    context 'when event is a single object' do
      let(:event) { ['event'] }

      subject { described_class.produce(event) }

      it 'calls produce on instance with correct parameters' do
        expect_any_instance_of(described_class).to receive(:produce).with(event)

        subject
      end
    end

    context 'when event is an array of events' do
      let(:events) { ['event1', 'event2', 'event3'] }

      subject { described_class.produce(events) }

      it 'calls produce on instance' do
        expect_any_instance_of(described_class).to receive(:produce).with(events)

        subject
      end
    end
  end
end
