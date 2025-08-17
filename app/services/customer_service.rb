class CustomerService
  def create_customer(attrs)
    customer = Customer.new(attrs)
    if customer.save
      customer
    end
  end
end