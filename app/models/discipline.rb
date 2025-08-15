class Discipline < ApplicationRecord
    validates :name, length: { maximum: 100 }, presence: true
    validates :abbreviation, length: { maximum: 10 }, presence: true
    validates :isForProvider, presence: true
  
    after_initialize :set_defaults
  
    private
  
    def set_defaults
      self.name ||= ""
      self.abbreviation ||= ""
      self.isForProvider || false
    end
end
