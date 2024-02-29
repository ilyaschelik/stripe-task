class Invoice::PaymentSucceed 
  attr_reader :invoice

  STATUS_PAID = 'paid'.freeze

  def initialize(invoice:)
    @invoice = Invoice::Object.new(id: invoice[:id], 
                                              status: invoice[:status],
                                              paid: invoice[:paid],
                                              subscription_id: invoice[:subscription_id]) 
  end

  def run
    subscription_instance.update!(status: STATUS_PAID) if subscription_instance && invoice_payment_logic_satisfied?
  end

  private
  
  def invoice_payment_logic_satisfied?
    invoice.subscription_id == subscription_instance.subscription_id && subscription.latest_invoice == id && paid
  end

  def subscription_instance
    @subscription_instance ||= Subscription.find_by(subscription_id: invoice.subscription_id)
  end

  def subscription
    invoice.subscription
  end

  def paid
    invoice.paid
  end

  def id
    invoice.id 
  end
end