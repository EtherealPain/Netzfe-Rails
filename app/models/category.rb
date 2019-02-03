class Category < ApplicationRecord
    has_many :activities
        
    validate :setup_status, on: :create
    validates :description, presence: true
    validates :status, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

    def setup_status
        self.status = 1
    end
    
end
