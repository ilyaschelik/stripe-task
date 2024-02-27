class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.sorted
  end
end
