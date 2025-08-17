class CreateFranchises < ActiveRecord::Migration[8.0]
  def change
    create_table :franchises do |t|
      t.string :name
      t.string :buy_in_reason
      t.string :vision
      t.string :involvement
      t.references :capital, null: false, foreign_key: true
      t.boolean :finance_required
      t.datetime :start_date

      t.timestamps
    end
  end
end
