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
    if will_save_change_to_deadline? && deadline.present? && deadline < DateTime.now
	   errors.add(:deadline, "Deadline can not be in the past")
    end
  end

  def check_status
    if deadline > DateTime.now
      self.status = 1
    end
  end

  def add_participant(following_user)
    if status == 0 #it is still open
      following_user.follow self
      true
    else
      errors.add(:base, "The Activity has ended, you cannot join as participant")
      false
    end
  end


  def creator
    #self.activity_id.nil? ? self.user.id : self.activity_id.user.id
    self.user.id
  end


end
