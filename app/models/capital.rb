class Capital < ApplicationRecord
  has_many :franchises, dependent: :nullify
  has_many :customers
end
