class Subscription::CancellationService
  attr_reader :subscription

  STATUS_PAID = 'paid'
  STATUS_ACTIVE = 'active'

  def initialize(subscription:)
    @subscription = Subscription::Object.new(subscription: subscription)
  end

  def run
    subscription = Subscription.find_by(subscription_id: subscription.id)
    subscription.update!(status: @status) if subscription && cancellation_logic_satisfied?
  end

  private
  
  def cancellation_logic_satisfied?
    @debugger
    @status = STATUS_PAID if [STATUS_PAID, STATUS_ACTIVE].include? subscription.status
  end
end