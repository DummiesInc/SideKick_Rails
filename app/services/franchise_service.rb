# app/services/franchise_service.rb
class FranchiseService

  def list_franchises(attr)
    # Pagination with kaminari gem
    # franchises = Franchise
    #   .includes(:capital)
    #                .page(attr[:page]).per(attr[:per_page])
    #

    franchises = Franchise.all

    # Filter by name if provided
    puts "what - #{attr[:franchise_name]}"
    if attr[:franchise_name].present?
      puts "testing"
      # Use ILIKE for case-insensitive search (Postgres)
      franchises = franchises.where("name ILIKE ?", "%#{attr[:franchise_name]}%")

    end

    # Eager load associations
    franchises = franchises.includes(:capital)

    # Paginate
    franchises = franchises.page(attr[:page]).per(attr[:per_page])

    {

      franchises: franchises.map do |franchise|
        {
          id: franchise.id,
          name: franchise.name,
          capital:{
            name: franchise.capital.name,
          }
        }
      end,
      totalPages: franchises.total_pages,
      totalCount: franchises.total_count
    }
  end
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
