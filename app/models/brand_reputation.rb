class BrandReputation < ApplicationRecord
  self.table_name = "brand_reputation"
  belongs_to :franchise

  def as_json(options = {})
    super(options).transform_keys { |key| key.camelize(:lower) }
  end
end