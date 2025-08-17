class State < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, length: { maximum: 2 }, uniqueness: true

end
