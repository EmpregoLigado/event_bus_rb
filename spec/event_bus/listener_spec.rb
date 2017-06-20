describe EventBus::Listener do
  let(:event_name) { 'name' }
  let(:block) { ->(event) { true } }

  describe '.on' do
    before do
      allow(EventBus::Config.broker).to receive(:consume).with(event_name, &block)
    end

    subject { described_class.on(event_name, &block) }

    context 'when event name is present' do
      it 'consumes the event on the broker' do
        expect(EventBus::Config.broker).to receive(:consume).with(event_name, &block)

        subject
      end

      it 'does not raise an MissingAttributeError' do
        expect{subject}.not_to raise_error
      end
    end

    context 'when event name is not present' do
      let(:event_name) { nil }

      it 'does not produce the event on the broker' do
        expect(EventBus::Config.broker).not_to receive(:consume)

        subject rescue nil
      end

      it 'raises an MissingAttributeError' do
        expect{subject}.to raise_error(EventBus::MissingAttributeError)
      end
    end
  end
end
