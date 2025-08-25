class RenameTables < ActiveRecord::Migration[8.0]
  def change
    rename_table :financial_information_tables, :financial_information
    rename_table :brand_reputation_tables, :brand_reputation
    rename_table :operation_information_tables, :operation_information
  end
end
