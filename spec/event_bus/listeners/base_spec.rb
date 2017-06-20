describe EventBus::Listeners::Base do
  describe '.bind' do
    let(:method_handle) { 'handle' }
    let(:event_name) { 'event_name' }
    let(:listener_config) { { listener_class: described_class, method: method_handle, routing_key: event_name } }

    subject { described_class.bind(method_handle, event_name) }

    it 'register a new listener on the Manager' do
      expect(EventBus::Listeners::Manager).to receive(:register_listener_configuration).with(listener_config)

      subject
    end
  end
end
