class Subscription::CancelService
  attr_reader :subscription

  STATUS_CANCELED = 'canceled'.freeze
  STATUS_PAID = 'paid'.freeze

  def initialize(subscription:)
    @subscription = Subscription::Object.new(id: subscription[:id], 
                                              customer_id: subscription[:customer_id],
                                              latest_invoice_id: subscription[:latest_invoice_id],
                                              status: subscription[:status]) 
  end

  def run
    subscription_instance.update!(status: @status) if subscription_instance && cancellation_logic_satisfied?
  end

  private

  def subscription_instance
    @subscription_instance ||= Subscription.find_by(subscription_id: subscription.id)
  end
  
  def cancellation_logic_satisfied?
    @status = STATUS_CANCELED if subscription.latest_invoice.paid && subscription_instance.status == STATUS_PAID
  end
end
