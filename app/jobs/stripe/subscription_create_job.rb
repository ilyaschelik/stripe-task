class Stripe::SubscriptionCreateJob < ApplicationJob
  queue_as :subscription_create

  def perform(subscription)
    Subscription::CreateService.new(subscription: subscription).run
  end
end
