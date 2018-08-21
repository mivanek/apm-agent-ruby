# frozen_string_literal: true

require 'elastic_apm/transport/connection'
require 'elastic_apm/serializers'

module ElasticAPM
  # @api private
  class Transport
    class UnrecognizedResource < InternalError; end

    def initialize(config)
      @config = config
      @connection = Connection.new(intake_url)

      @serializers = Struct.new(:transaction, :span, :error).new(
        Serializers::TransactionSerializer.new(config),
        Serializers::SpanSerializer.new(config),
        Serializers::ErrorSerializer.new(config)
      )
    end

    attr_reader :config

    # rubocop:disable Metrics/MethodLength
    def submit(resource)
      serialized =
        case resource
        when Transaction
          @serializers.transaction.build(resource)
        when Span
          @serializers.span.build(resource)
        when Error
          @serializers.error.build(resource)
        else
          raise UnrecognizedResource
        end

      @connection.write serialized.to_json
    end
    # rubocop:enable Metrics/MethodLength

    def close!
      @connection.close!
    end

    private

    def intake_url
      config.server_url + '/v2/intake'
    end
  end
end
