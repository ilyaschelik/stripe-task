class Stripe::SubscriptionCreateJob < ApplicationJob
  queue_as :subscription_create

  def perform(subscription)
    # logger.info "performing creation task..."
    # Subscription::CreateService.new(id: id, customer_id: customer_id, status: status).run
    # debugger
    Subscription::CreateService.new(subscription).run
  end
end
