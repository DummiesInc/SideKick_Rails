class FinancialInformation < ApplicationRecord
  # Rails expect table to be plural
  # If the table name is not pluralized, gotta do this line below
  # Otherwise Active Record .includes() does not work properly
  self.table_name = "financial_information"
  belongs_to :franchise

  def as_json(options = {})
    super(options).transform_keys { |key| key.camelize(:lower) }
  end
end