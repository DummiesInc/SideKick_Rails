class OperationInformation < ApplicationRecord
  self.table_name = "operation_information"
  belongs_to :franchise

  def as_json(options = {})
    super(options).transform_keys { |key| key.camelize(:lower) }
  end
end