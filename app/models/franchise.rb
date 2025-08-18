class Franchise < ApplicationRecord
  belongs_to :capital
  has_many :investment_sites
end
