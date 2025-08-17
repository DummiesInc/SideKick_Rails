# app/services/franchise_service.rb
class FranchiseService
  def list_franchises_for_customer(customer_id)
    customer = Customer.find_by(id: customer_id)

    puts customer.buy_in_reason
    return {
      customerName: '',
      buyInReason: '',
      vision: '',
      involvement: '',
      capital: '',
      franchises: []
    } unless customer

    capital_id = customer.capital_id
    capital = Capital.find_by(id: capital_id)
    franchises = Franchise.where(capital_id: capital_id).includes(:capital)


    {
      customerName: customer.first_name + ' ' + customer.last_name,
      buyInReason: customer.buy_in_reason,
      vision: customer.vision,
      involvement: customer.involvement,
      capital: capital.name,
      franchises: franchises.map do |franchise|
        {
          id: franchise.id,
          name: franchise.name,
          capital: {
            id: franchise.capital.id,
            name: franchise.capital.name
          }
        }
      end
    }
  end
end
