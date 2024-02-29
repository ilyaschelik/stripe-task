require 'rails_helper'

describe Invoice::PaymentSucceed, type: :service do

  context 'when invoice.payment_succeeded event is received' do

    let(:subscription_id) { 'subscription_id' }
    let(:invoice_id) { 'invoice_id' }
    let(:invoice_status) { 'paid' }

    let!(:subscription_instance) { Subscription.create(subscription_id: subscription_id, status: 'unpaid') }

    it "updates the subscription state to 'paid'" do

      invoice_data = {
          id: invoice_id,
          status: described_class::STATUS_PAID,
          paid: true,
          subscription_id: subscription_id
      }

      allow(Stripe::Subscription).to receive(:retrieve).and_return(double('subscription', latest_invoice: invoice_id))
      payment_succeed_service = described_class.new(invoice: invoice_data)

      expect { payment_succeed_service.run }.not_to change(Subscription, :count)

      updated_subscription = Subscription.last
      expect(updated_subscription.subscription_id).to eq(subscription_id)
      expect(updated_subscription.status).to eq(described_class::STATUS_PAID)
    end
  end
end
