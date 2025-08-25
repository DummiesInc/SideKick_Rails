class Franchise < ApplicationRecord
  belongs_to :capital
  has_many :investment_sites
  has_one :financial_information
  has_one :operation_information
  has_one :brand_reputation

  def as_json(options = {})
    super(options).transform_keys { |key| key.camelize(:lower) }
  end
end
