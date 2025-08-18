class RemoveCapitalIdFromInvestmentSite < ActiveRecord::Migration[8.0]
  def change
    remove_reference :investment_sites, :capital, foreign_key: true
  end
end
