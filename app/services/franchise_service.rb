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

  def franchise_profile(franchise_id)
    franchise = Franchise
                  .includes(:brand_reputation)
                  .includes(:financial_information)
                  .includes(:operation_information)
                  .find_by(id: franchise_id)
    return {
      franchise: {},
      brandReputation: nil,
      financialInformation: nil,
      operationInformation: nil
    } unless franchise.present?

    {
      franchise: franchise,
      brandReputation: franchise.brand_reputation&.as_json,
      financialInformation: franchise.financial_information&.as_json,
      operationInformation: franchise.operation_information&.as_json
    }

  end
  def list_franchises_for_customer(customer_id)
    customer = Customer.find_by(id: customer_id)

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

    # I have other tables that's linked to Franchise via franchise_id. Can I do more includes in this statement?
    franchises = Franchise.where(capital_id: capital_id).includes(:capital)
                   .includes(:brand_reputation)
                   .includes(:financial_information)
                   .includes(:operation_information)


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
          },
          financialInformation: franchise.financial_information&.as_json,
          operationInformation: franchise.operation_information&.as_json,
          brandReputation: franchise.brand_reputation&.as_json,
        }
      end
    }
  end

  # NESTED_MODELS = {
  #   franchise: Franchise,
  #   # brandReputation: BrandReputation,
  #   # financialInformation: FinancialInformation,
  #   # operationInformation: OperationInformation
  # }
  # def update_franchise_profile(franchise_id, body)
  #   franchise = Franchise.find_by(id: franchise_id)
  #   return unless franchise
  #
  #   NESTED_MODELS.each do |key, model_class|
  #     next unless body[key].present?
  #
  #     # Transform keys from camelCase to snake_case for Rails
  #     attributes = body[key].deep_transform_keys(&:underscore)
  #
  #     if key == :franchise
  #       franchise.update(attributes)
  #     else
  #       nested = model_class.find_or_initialize_by(franchise_id: franchise.id)
  #       nested.assign_attributes(attributes)
  #       nested.save
  #     end
  #   end
  # end


  # def update_franchise_profile(franchise_id, body)
  #
  #   franchise = Franchise.find_by(id: franchise_id)
  #   return false unless franchise   # <-- just return false if not found
  #
  #   franchise.update(body)
  # end

  def update_franchise_profile(franchise_id, body)
    franchise = Franchise.find_by(id: franchise_id)
    return unless franchise
    franchise_params = body[:franchise].deep_transform_keys(&:underscore)
    franchise.update(franchise_params) if body[:franchise].present?

    # Update or create brand reputation
    if body[:brand_reputation].present?
      brand = BrandReputation.find_or_initialize_by(franchise_id: franchise.id)
      # brand_reputation_params = body[:brand_reputation].deep_transform_keys(&:underscore)
      brand.assign_attributes(body[:brand_reputation])
      brand.save
    end

    # Update or create financial info
    if body[:financial_information].present?
      financial = FinancialInformation.find_or_initialize_by(franchise_id: franchise.id)
      # financial_information_params = body[:financialInformation].deep_transform_keys(&:underscore)
      financial.assign_attributes(body[:financial_information])
      financial.save
    end

    # Update or create operation info
    if body[:operation_information].present?
      operation = OperationInformation.find_or_initialize_by(franchise_id: franchise.id)
      # operation.update(body[:operation_information])
      # operation_information_params = body[:operationInformation].deep_transform_keys(&:underscore)
      operation.assign_attributes(body[:operation_information])
      # operation.assign_attributes(body[:operation_information])
      operation.save
    end

  end
end
