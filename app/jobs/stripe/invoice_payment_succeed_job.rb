class Stripe::InvoicePaymentSucceedJob < ApplicationJob
  queue_as :invoice_payment_succeeded

  def perform(invoice)
    Invoice::PaymentSucceed.new(invoice: invoice).run
  end
end
