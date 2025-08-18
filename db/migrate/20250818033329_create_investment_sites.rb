class CreateInvestmentSites < ActiveRecord::Migration[8.0]
  def change
    create_table :investment_sites do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.references :franchise, null: false, foreign_key: true
      t.references :capital, null: false, foreign_key: true

      t.timestamps
    end
  end
end
