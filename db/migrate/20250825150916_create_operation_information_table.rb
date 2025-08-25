class CreateOperationInformationTable < ActiveRecord::Migration[8.0]
  def change
    create_table :operation_information_tables do |t|
      t.string :ownership_model
      t.integer :staff_count_requirement
      t.boolean :approved_supplier_only
      t.boolean :corporate_supplier_only

      t.references :franchise, null: false, foreign_key: true
      t.timestamps
    end
  end
end
