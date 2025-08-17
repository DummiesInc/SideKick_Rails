class Customer < ApplicationRecord
  belongs_to :capital

  def initialize(attrs = {})
    super   # always call super to let ActiveRecord set attributes
    self.first_name ||= ""
    self.last_name || ""
    self.buy_in_reason || ""
    self.vision || ""
    self.involvement || ""
    self.capital || 1
    self.finance_required || false
    self.start_date || "10/1/1776"
  end
end
