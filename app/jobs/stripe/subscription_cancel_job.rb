class Stripe::SubscriptionCancelJob < ApplicationJob
  queue_as :subscription_cancel

  def perform(subscription)
    Subscription::CancelService.new(subscription: subscription).run
  end
end
