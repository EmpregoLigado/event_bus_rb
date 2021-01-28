# frozen_string_literal: true

module EventBus
  class Event
    attr_reader :name, :headers, :body, :schema_version

    def initialize(name, body, schema_version = 1.0)
      @name = name
      @body = JSON.parse(body) rescue body
      @schema_version = @body['headers']['schemaVersion'] rescue schema_version
      generate_headers if has_name?
      build_payload if @body&.has_key?('headers')
    end

    def payload
      {
        headers: headers,
        body: body
      }.to_json
    end

    def has_body?
      body && !body.empty?
    end

    def has_name?
      name && !name.empty?
    end

    private

    def build_payload
      @headers = body['headers']
      @body = body['body']
    end

    def generate_headers
      header_spec = name.split('.')

      @headers = {
        appName: EventBus::Config::APP_NAME,
        resource: header_spec[0],
        origin: header_spec[1],
        action: header_spec[2],
        schemaVersion: schema_version
      }
    end
  end
end
