# frozen_string_literal: true

module ElasticAPM
  module Serializers
    # @api private
    class SpanSerializer < Serializer
      # rubocop:disable Metrics/AbcSize
      def build(span)
        span = {
          id: span.id,
          parent: span.parent && span.parent.id,
          name: span.name,
          type: span.type,
          start: ms(span.relative_start),
          duration: ms(span.duration),
          context: span.context && { db: span.context.to_h },
          stacktrace: span.stacktrace.to_a
        }

        { span: span }
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
