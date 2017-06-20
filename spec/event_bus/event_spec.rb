require "spec_helper"

describe EventBus::Event do
  context 'when body comes from an application' do
    let(:name) { 'omg.lol.bbq' }
    let(:body) { { number: 666, something: "cool" } }
    let(:event) { described_class.new(name, body) }
    let(:schemaVersion) { 1.0 }

    it "holds the #name value" do
      expect(event.name).to eq "omg.lol.bbq"
    end

    it "holds the #body value" do
      expect(event.body).to eq number: 666, something: "cool"
    end

    describe '#payload' do
      let(:payload_expected) do
        {
          headers: {
            appName: EventBus::Config::APP_NAME,
            resource: 'omg',
            origin: 'lol',
            action: 'bbq',
            schemaVersion: schemaVersion
            },
            body: body
        }.to_json
      end

      it "returns payload value in JSON format" do
        expect(event.payload).to eq payload_expected
      end

      context 'with non default schemaVersion' do
        let(:schemaVersion) { 4.2 }
        let(:event) { described_class.new(name, body, schemaVersion) }

        it 'changes default schemaVersion' do
          expect(event.payload).to eq payload_expected
        end
      end
    end
  end

  context 'when body comes from RabbitMQ' do
    let(:name) { 'omg.lol.bbq' }
    let(:event) { described_class.new(name, body_from_rabbit.to_json) }
    let(:body) { { number: 666, something: "cool" } }
    let(:schemaVersion) { 1.9 }
    let(:body_from_rabbit) do
      {
        headers: {
          appName: EventBus::Config::APP_NAME,
          resource: 'omg',
          origin: 'lol',
          action: 'bbq',
          schemaVersion: schemaVersion
          },
          body: body
      }
    end

    it "holds the #name value" do
      expect(event.name).to eq "omg.lol.bbq"
    end

    it "returns the body inside the body" do
      expect(event.body).to eq JSON.parse(body.to_json)
    end

    describe '#payload' do
      it "returns payload value in JSON format" do
        expect(event.payload).to eq body_from_rabbit.to_json
      end
    end
  end

  let(:name) { 'omg.lol.bbq' }
  let(:body) { { number: 666, something: "cool" } }
  let(:event) { described_class.new(name, body) }

  describe '#has_body?' do
    subject { event.has_body? }

    context 'when body is nil' do
      let(:body) { nil }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when body is empty' do
      let(:body) { {} }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when body is present' do
      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe '#has_name?' do
    subject { event.has_name? }

    context 'when name is nil' do
      let(:name) { nil }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when name is empty' do
      let(:name) { '' }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'when name is present' do
      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end
end
