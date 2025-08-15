class State < ApplicationRecord
    validates :name, length: { maximum: 100 }, presence: true
    validates :abbreviation, length: { maximum: 3 }, presence: true
  
    after_initialize :set_defaults
  
    private
  
    def set_defaults
      self.name ||= ""
      self.abbreviation ||= ""
    end
end
  