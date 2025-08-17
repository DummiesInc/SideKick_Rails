# app/services/franchise_service.rb
class FranchiseService
  def list_franchises_for_customer(customer_id)
    customer = Customer.find_by(id: customer_id)
    return [] unless customer

    capital_id = customer.capital_id
    franchises = Franchise.where(capital_id: capital_id).includes(:capital)

    franchises.map do |franchise|
      {
        id: franchise.id,
        name: franchise.name,
        capital: {
          id: franchise.capital.id,
          name: franchise.capital.name
        }
      }
    end
  end
end
