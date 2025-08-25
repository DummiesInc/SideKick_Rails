class CreateBrandReputationTable < ActiveRecord::Migration[8.0]
  def change
    create_table :brand_reputation_tables do |t|
      t.date :founding_date, null: true
      t.string :franchise_program_year
      t.integer :total_units
      t.float :growth_rate
      t.integer :satisfaction_score

      t.references :franchise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
