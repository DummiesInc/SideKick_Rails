class RenameFinancialInformationRelationship < ActiveRecord::Migration[8.0]
  def change
    remove_reference :financial_information, :capital, foreign_key: true
  end
end
