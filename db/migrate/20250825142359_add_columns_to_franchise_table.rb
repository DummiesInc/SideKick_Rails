class AddColumnsToFranchiseTable < ActiveRecord::Migration[8.0]
  def change
    add_column :franchises, :website, :string
    add_column :franchises, :mission, :string
    add_column :franchises, :contact_person, :string
    add_column :franchises, :phone_umber, :string
  end
end
