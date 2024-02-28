class Subscription::CreateService
  attr_reader :subscription

  DEFAULT_CREATION_STATUS = 'unpaid'

  def initialize(subscription)
    @subscription = Subscription::Object.new(id: subscription[:id], 
                                              customer_id: subscription[:customer_id], 
                                              status: subscription[:status]) 
  end

  def run 
    Subscription.create!(subscription_id: subscription.id, 
                          customer_id: subscription.customer_id, 
                          customer_name: subscription.customer_name, 
                          customer_email: subscription.customer_email, 
                          status: DEFAULT_CREATION_STATUS) if unpaid_subscription?
  end

  private 

  def unpaid_subscription?
    subscription.id
  end
end