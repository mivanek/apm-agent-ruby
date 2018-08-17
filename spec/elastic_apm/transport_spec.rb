# frozen_string_literal: true

require 'spec_helper'
require 'elastic_apm/transport'

Thread.abort_on_exception = true

module ElasticAPM
  RSpec.describe Transport do
    describe '#submit' do
      it 'takes records and sends them off', :mock_intake do
        agent = Agent.new Config.new
        instrumenter = Instrumenter.new agent

        transport = Transport.new agent.config
        transaction = Transaction.new instrumenter, 'T' do |t|
          t.span 'span 1' do
          end
        end

        transport.submit transaction

        transport.close!

        expect(MockAPMServer.requests.length).to be 1
        expect(MockAPMServer.transactions.length).to be 1
      end
    end
  end
end
