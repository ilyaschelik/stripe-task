class Subscription::Object
  attr_reader :id, 
              :customer_id, 
              :customer_email, 
              :customer_name, 
              :latest_invoice_id,
              :latest_invoice,
              :status 
  

  def initialize(id:, customer_id:, status:, latest_invoice_id: nil)
    @id = id
    @customer_id = customer_id
    @customer_name = customer.name
    @customer_email = customer.email
    @latest_invoice_id = latest_invoice_id
    @status = status
  end

  def latest_invoice
    @latest_invoice ||= Stripe::Invoice.retrieve(latest_invoice_id) if latest_invoice_id
  end
  
  private 

  def customer
    @customer ||= Stripe::Customer.retrieve(@customer_id)
  end
end