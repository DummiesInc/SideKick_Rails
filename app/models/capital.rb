class Capital < ApplicationRecord
  has_many :franchises, dependent: :nullify
end
