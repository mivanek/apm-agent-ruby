# frozen_string_literal: true

module ElasticAPM
  module Serializers
    RSpec.describe TransactionSerializer do
      let(:agent) { Agent.new(Config.new) }
      let(:instrumenter) { Instrumenter.new agent }
      let(:builder) { described_class.new agent.config }

      before do
        @mock_uuid = SecureRandom.uuid
        allow(SecureRandom).to receive(:uuid) { @mock_uuid }
      end

      describe '#build', :mock_time do
        context 'a transaction without spans' do
          let(:transaction) do
            Transaction.new(instrumenter, 'GET /something', 'request') do
              travel 100
            end.done 200
          end
          subject { builder.build(transaction) }
          it 'builds' do
            should match(
              transaction: {
                "id": @mock_uuid,
                "name": 'GET /something',
                "type": 'request',
                "result": '200',
                "context": { custom: {}, tags: {} },
                "duration": 100.0,
                "timestamp": Time.utc(1992, 1, 1).iso8601(3),
                "sampled": true
              }
            )
          end
        end

        xcontext 'with dropped spans' do
          it 'includes count' do
            config = Config.new(transaction_max_spans: 2)
            agent = Agent.new(config)
            instrumenter = Instrumenter.new agent
            transaction = Transaction.new instrumenter, 'T' do |t|
              t.span '1'
              t.span '2'
              t.span 'dropped'
              t
            end

            result = Transactions.new(config).build(transaction)

            expect(result.dig(:span_count, :dropped, :total)).to be 1
          end
        end
      end
    end
  end
end
