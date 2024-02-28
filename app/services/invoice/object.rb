class Invoice::Object

  attr_reader :id, :status, :paid, :subscription, :subscription_id

  def initialize(id:, status:, paid:, subscription_id:)
    @id = id
    @status = status
    @paid = paid
    @subscription_id = subscription_id
  end

  def subscription
    @subscription ||= Stripe::Subscription.retrieve(subscription_id)
  end
end