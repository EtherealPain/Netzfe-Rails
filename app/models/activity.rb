class Activity < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  acts_as_followable
end
