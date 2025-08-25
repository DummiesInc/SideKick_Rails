class RenameFranchiseNumberColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :franchises, :phone_umber, :phone_number
  end
end
