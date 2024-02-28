# spec/services/subscription/create_service_spec.rb

require 'rails_helper'

RSpec.describe Subscription::CreateService do
  describe '#run' do
    context 'when subscription is unpaid' do
      xit 'creates a new subscription' do
        subscription_data = {
          id: 'subscription_id',
          customer_id: 'customer_id',
          status: 'active',
        }

        subscription_service = described_class.new(subscription_data)

        expect {
          subscription_service.run
        }.to change(Subscription, :count).by(1)

        created_subscription = Subscription.last
        expect(created_subscription.subscription_id).to eq('subscription_id')
        expect(created_subscription.customer_id).to eq('customer_id')
        expect(created_subscription.status).to eq(Subscription::CreateService::DEFAULT_CREATION_STATUS)
      end
    end

    context 'when subscription is not unpaid' do
      xit 'does not create a new subscription' do
        subscription_data = {
          id: 'subscription_id',
          customer_id: 'customer_id',
          status: 'paid',
        }

        subscription_service = described_class.new(subscription_data)

        expect {
          subscription_service.run
        }.not_to change(Subscription, :count)
      end
    end
  end
end
