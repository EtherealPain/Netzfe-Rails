class Category < ApplicationRecord
    has_many :activities
        
    validates :description, presence: true
    validates :status, inclusion: { in: [0,1]}
    validates :status, numericality: true

    validate :setup_status, on: :create

    def setup_status
        self.status = 1
    end
end
