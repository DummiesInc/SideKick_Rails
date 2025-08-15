class CreateDisciplines < ActiveRecord::Migration[8.0]
  def change
    create_table :disciplines do |t|
      t.string :name, limit: 100
      t.string :abbreviation, limit: 10
      t.boolean :isForProvider

      t.timestamps
    end
  end
end
