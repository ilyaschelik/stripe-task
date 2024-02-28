require 'rails_helper'

describe Subscription::CancelService, type: :service do

  STATUS_UNPAID = 'unpaid'.freeze

  context 'when customer.subscription.deleted event is received' do   
    let!(:paid_subscription_instance) { Subscription.create(subscription_id: 'subscription_id', status: described_class::STATUS_PAID) }
    let!(:unpaid_subscription_instance) { Subscription.create(subscription_id: 'subscription_id2', status: STATUS_UNPAID) }
 
    it "cancels the existing subscription and changes the state to 'canceled'" do
      subscription_data = {
        id: 'subscription_id',
        latest_invoice_id: 'latest_invoice_id',
        status: 'active'
      }

      allow(Stripe::Customer).to receive(:retrieve).and_return(double('customer', name: 'Fake Name', email: 'fakename@fakename.com'))
      allow(Stripe::Invoice).to receive(:retrieve).and_return(double('latest_invoice', paid: true, status: described_class::STATUS_CANCELED))


      subscription_cancel_service = described_class.new(subscription: subscription_data)

      expect {
        subscription_cancel_service.run
      }.not_to change(Subscription, :count)

      canceled_subscription = Subscription.find_by(subscription_id: subscription_data[:id])

      expect(canceled_subscription.subscription_id).to eq('subscription_id')
      expect(canceled_subscription.status).to eq(described_class::STATUS_CANCELED)
    end

    it "does not cancel if the subscription latest invoice is not paid" do
      subscription_data = {
        id: 'subscription_id',
        latest_invoice_id: 'latest_invoice_id',
        status: 'active'
      }

      allow(Stripe::Customer).to receive(:retrieve).and_return(double('customer', name: 'Fake Name', email: 'fakename@fakename.com'))
      allow(Stripe::Invoice).to receive(:retrieve).and_return(double('latest_invoice', paid: false, status: 'unpaid'))

      subscription_cancel_service = described_class.new(subscription: subscription_data)

      expect {
        subscription_cancel_service.run
      }.not_to change(Subscription, :count)

      canceled_subscription = Subscription.find_by(subscription_id: subscription_data[:id])

      expect(canceled_subscription.subscription_id).to eq('subscription_id')
      expect(canceled_subscription.status).to eq(described_class::STATUS_PAID)
    end

    it "does not cancel if the existing subscription status is unpaid" do

      subscription_data = {
        id: 'subscription_id2',
        latest_invoice_id: 'latest_invoice_id',
        status: 'active'
      }

      allow(Stripe::Customer).to receive(:retrieve).and_return(double('customer', name: 'Fake Name', email: 'fakename@fakename.com'))
      allow(Stripe::Invoice).to receive(:retrieve).and_return(double('latest_invoice', paid: false, status: 'unpaid'))

      subscription_cancel_service = described_class.new(subscription: subscription_data)

      expect {
        subscription_cancel_service.run
      }.not_to change(Subscription, :count)

      canceled_subscription = Subscription.find_by(subscription_id: subscription_data[:id])

      expect(canceled_subscription.subscription_id).to eq('subscription_id2')
      expect(canceled_subscription.status).to eq(STATUS_UNPAID)
    end
  end  
end
