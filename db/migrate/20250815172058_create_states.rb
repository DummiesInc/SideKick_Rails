class CreateStates < ActiveRecord::Migration[8.0]
  def change
    create_table :states do |t|
      t.string :name, limit: 100
      t.string :abbreviation, limit: 3

      t.timestamps
    end
  end
end
