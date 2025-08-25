class CreateFinancialInformationTable < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_information_tables do |t|
      t.integer :royalty_fee
      t.integer :marketing_fee
      t.integer :software_license_fee
      t.integer :renewal_fee
      t.integer :training_fee
      t.integer :supply_fee
      t.float :profit_margin
      t.integer :net_worth_requirement
      t.integer :liquidity_requirement

      t.references :franchise, null: false, foreign_key: true
      t.references :capital, null: false, foreign_key: true
      t.timestamps
    end
  end
end
