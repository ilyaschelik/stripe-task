class Stripe::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    # Replace this endpoint secret with your endpoint's unique secret
    # If you are testing with the CLI, find the secret by running 'stripe listen'
    # If you are using an endpoint defined with the API or dashboard, look in your webhook settings
    # at https://dashboard.stripe.com/webhooks
    webhook_secret = ENV['STRIPE_WEBHOOK_SECRET']
    payload = request.body.read
    if !webhook_secret.empty?
      # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil
  
      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, webhook_secret
        )
      rescue JSON::ParserError => e
        # Invalid payload
        render plain: 'Invalid payload', status: 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        puts '⚠️  Webhook signature verification failed.'
        render plain: 'Webhook signature verification failed', status: 400
        return
      end
    else
      data = JSON.parse(payload, symbolize_names: true)
      event = Stripe::Event.construct_from(data)
    end

    event_type = event['type']
    data = event['data']
    data_object = data['object']
    # debugger

    if event.type == 'customer.subscription.created'
      Stripe::SubscriptionCreateJob.perform_later(subscription_data(event.data.object))
    end

    if event.type == 'customer.subscription.deleted'
      Stripe::SubscriptionCancelJob.perform_later(subscription_data(event.data.object))
    end

    if event.type ==  'invoice.payment_succeeded'
      Stripe::InvoicePaymentSucceedJob.perform_later(invoice_data(event.data.object))
    end

    render json: { message: :success }
  end

  private 
  
  def subscription_data(subscription)
    {
      id: subscription.id,
      customer_id: subscription.customer,
      latest_invoice_id: subscription.latest_invoice,
      status: subscription.status
    }
  end

  def invoice_data(invoice)
    {
      id: invoice.id,
      status: invoice.status,
      paid: invoice.paid,
      subscription_id: invoice.subscription
    }
  end
end
