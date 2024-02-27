class Subscription::Object
  attr_reader :id, 
  :customer_id, 
  :customer_email, 
  :customer_name, 
  :status 

  def initialize(id:, customer_id:, status:)
  @id = id
  @customer_id = customer_id
  @customer_name = customer.name
  @customer_email = customer.email
  @status = status
  end

  private 

  def customer
  @customer ||= Stripe::Customer.retrieve(@customer_id)
  end


  # attr_reader :id, 
  #             :customer_id, 
  #             :customer_email, 
  #             :customer_name, 
  #             :status 

  # def initialize(subscription:)
  #   @id = subscription.id
  #   @customer_id = subscription.customer
  #   @customer_name = customer.name
  #   @customer_email = customer.email
  #   @status = subscription.status
  # end

  # private 

  # def customer
  #   @customer ||= Stripe::Customer.retrieve(@customer_id)
  # end
end