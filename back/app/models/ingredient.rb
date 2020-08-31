class Ingredient < ApplicationRecord
    belongs_to :user

    before_validation :calculate_cost_used
    
    validates :name, presence: true
    validates :trader, presence: true
    validates :unit, presence: true
    validates :cost, presence: true
    validates :budomari, presence: true
    validates :unit_used, presence: true
    validates :converted_number, presence: true
    validates :cost_used, presence: true

    private
    
    def calculate_cost_used
        self.cost_used = converted_number * cost / budomari
    end
end
