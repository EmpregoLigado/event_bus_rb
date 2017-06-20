describe EventBus::Listeners::Manager do
  let(:method_handle) { 'handle' }
  let(:event_name) { 'event_name' }
  let(:listener_config) { { listener_class: described_class, method: method_handle, routing_key: event_name } }

  after do
    described_class.instance_variable_set('@listener_configurations', nil)
  end

  describe '.bind_all_listeners' do
    let(:configs) do
      configs = []

      10.times do |i|
        handle = "handle_#{i}"
        name = "event_#{i}"
        config = { listener_class: described_class, method: handle, routing_key: name }

        configs.push(config)
      end

      configs.each do |config|
        described_class.register_listener_configuration(config)
      end
    end

    subject { described_class.bind_all_listeners }

    it 'register all listeners on the Manager' do
      configs.each do |config|
        expect(EventBus::Listener).to receive(:on).with(config[:routing_key])
      end

      subject
    end
  end

  describe '.register_listener_configuration' do
    subject { described_class.register_listener_configuration(listener_config) }

    it 'adds given configuration to the list' do
      expect(described_class.send(:listener_configurations)).to be_empty

      subject

      expect(described_class.send(:listener_configurations).first).to eq listener_config
    end
  end

  describe '.listener_configurations' do
    subject { described_class.send(:listener_configurations) }

    context 'when configurations is not set up' do
      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end

    context 'when configurations is set up' do
      let(:value) { 'value' }

      before do
        described_class.instance_variable_set('@listener_configurations', value)
      end

      it 'returns the precious value' do
        expect(subject).to eq value
      end
    end
  end
end
