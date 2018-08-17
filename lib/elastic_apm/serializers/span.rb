# frozen_string_literal: true

module ElasticAPM
  module Serializers
    # @api private
    class Span < Serializer
      # rubocop:disable Metrics/AbcSize
      def build(span)
        {
          id: span.id,
          parent: span.parent && span.parent.id,
          name: span.name,
          type: span.type,
          start: ms(span.relative_start),
          duration: ms(span.duration),
          context: span.context && { db: span.context.to_h },
          stacktrace: span.stacktrace.to_a
        }
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
