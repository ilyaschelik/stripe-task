require 'rails_helper'

describe Invoice::PaymentSucceed, type: :service do

  context 'when invoice.payment_succeeded event is received' do
    it "updates the subscription state to 'paid'" do

      invoice_data(invoice)
        {
          id: 'invoice_id',
          status: 'invoice_status',
          paid: 'invoice_paid',
          subscription_id: 'invoice_subscription'
        }
      
      # subscription_data = {
      #   id: 'subscription_id',
      #   customer_id: 'customer_id',
      #   status: 'active'
      # }

      # allow(Stripe::Customer).to receive(:retrieve).and_return(double('customer', name: 'Fake Name', email: 'fakename@fakename.com'))
      # allow(Stripe::Invoice).to receive(:retrieve).and_return(double('invoice'))

      # subscription_create_service = described_class.new(subscription: subscription_data)
      
      # expect {
      #   subscription_create_service.run
      # }.to change(Subscription, :count).by(1)
      
      # created_subscription = Subscription.last

      # expect(created_subscription.subscription_id).to eq('subscription_id')

      # expect(created_subscription.customer_id).to eq('customer_id')
      # expect(created_subscription.customer_name).to eq('Fake Name')
      # expect(created_subscription.customer_email).to eq('fakename@fakename.com')
      # expect(created_subscription.status).to eq(described_class::DEFAULT_CREATION_STATUS)
    end
  end
end
