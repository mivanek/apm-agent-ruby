# frozen_string_literal: true

require 'json'

module ElasticAPM
  # @api private
  module Serializers
    # @api private
    class Serializer
      def initialize(config)
        @config = config
      end

      private

      def micros_to_time(micros)
        Time.at(ms(micros) / 1_000)
      end

      def ms(micros)
        micros.to_f / 1_000
      end
    end
  end
end

require 'elastic_apm/serializers/transaction'
require 'elastic_apm/serializers/span'
require 'elastic_apm/serializers/error'
