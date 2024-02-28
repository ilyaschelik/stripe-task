require 'rails_helper'

describe Subscription::CreateService, type: :service do

  context 'when customer.subscription.created event is received' do
    it "creates a new subscription with 'unpaid' state" do
      subscription_data = {
        id: 'subscription_id',
        customer_id: 'customer_id',
        status: 'active'
      }

      allow(Stripe::Customer).to receive(:retrieve).and_return(double('customer', name: 'Fake Name', email: 'fakename@fakename.com'))
      allow(Stripe::Invoice).to receive(:retrieve).and_return(double('invoice'))

      subscription_create_service = described_class.new(subscription: subscription_data)

      expect {
        subscription_create_service.run
      }.to change(Subscription, :count).by(1)

      created_subscription = Subscription.last

      expect(created_subscription.subscription_id).to eq('subscription_id')

      expect(created_subscription.customer_id).to eq('customer_id')
      expect(created_subscription.customer_name).to eq('Fake Name')
      expect(created_subscription.customer_email).to eq('fakename@fakename.com')
      expect(created_subscription.status).to eq(described_class::DEFAULT_CREATION_STATUS)
    end
  end
end
