class CreateCapitals < ActiveRecord::Migration[8.0]
  def change
    create_table :capitals do |t|
      t.string :name

      t.timestamps
    end
  end
end
