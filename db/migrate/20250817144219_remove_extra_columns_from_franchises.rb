class RemoveExtraColumnsFromFranchises < ActiveRecord::Migration[8.0]
  def up
    remove_columns :franchises, :buy_in_reason, :vision, :involvement, :finance_required, :start_date
  end

  def down
    add_column :franchises, :buy_in_reason, :string
    add_column :franchises, :vision, :string
    add_column :franchises, :involvement, :string
    add_column :franchises, :finance_required, :boolean
    add_column :franchises, :start_date, :datetime
  end
end
