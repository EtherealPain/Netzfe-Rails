class Activity < ApplicationRecord
  #relations
  belongs_to :user
  belongs_to :category
  has_one_attached :image
  has_one :room #An activity always has one room


  #VALIDATIONS
  validates_presence_of :user, :description, :deadline
  validate :deadline_is_not_in_the_past 



  #gems

  acts_as_followable

  acts_as_votable

  acts_as_commentable
  #methods
  def deadline_is_not_in_the_past
    if deadline_changed? && deadline.present? && deadline < DateTime.now
	  errors.add(:deadline, "Deadline can not be in the past")
    end
  end







end
