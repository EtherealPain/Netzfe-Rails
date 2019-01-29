class Activity < ApplicationRecord
  include PgSearch #this is to search
  multisearchable :against => :category_id #search register by category_id

  belongs_to :user
  belongs_to :category
  has_one_attached :image
  has_one :room, dependent: :destroy #An activity always has one room
  has_many :shares, :class_name => "Activity", :foreign_key => "activity_id"
  belongs_to :original, :class_name => "Activity", :foreign_key => "activity_id", optional: true

  #validates_presence_of :user, :title, :deadline
  validates :user_id, :category_id, :deadline, :title, presence: true

  validate :deadline_is_not_in_the_past

  acts_as_followable
  acts_as_votable
  acts_as_commentable

  def shared?
    self.shared
  end

  def deadline_is_not_in_the_past
    if will_save_change_to_deadline? && deadline.present? && self.deadline < DateTime.now
	   errors.add(:deadline, "Deadline can not be in the past")
    end
  end

  def check_status
    if self.deadline < DateTime.now
      self.update(status: "expired") unless (self.status == "finished" or self.status== "archived" )
      self.room.update(status: "finished") unless self.room.status == "archived" 
    end
  end

  def add_participant(following_user)

    if following_user.following? self
    errors.add(:base, "Cannot join an activity you're already participating in")
    end

    if self.status == "open" #it is still open
      following_user.follow self
      true
    else
      if self.status == "finished"
        errors.add(:base, "The Activity has ended, you cannot join as participant")
      elsif self.status == "expired"
        errors.add(:base, "The Activity has expired, you cannot join as participant")
      elsif self.status == "archived"
        errors.add(:base, "The Activity has been archived, you cannot join as participant")
      else
        errors.add(:base, "Unknown Activity status")
      end
      false
    end

  end

  def remove_paritipant(following_user)
    
    unless following_user.following? self
      errors.add(:base, "Cannot leave an activiy you haven't joined")
    end

    if self.status == "open" #it is still open
      following_user.stop_following self
      true
    else
      if self.status == "finished"
        errors.add(:base, "The Activity has ended, you cannot leave anymore")
      elsif self.status == "expired"
        errors.add(:base, "The Activity has expired, you cannot leave anymore")
      elsif self.status == "archived"
        errors.add(:base, "The Activity has been archived, you cannot leave anymore")
      else
        errors.add(:base, "Unknown Activity status")
      end
      false
    end 
  end

  def like_post(liking_user)

    if self.can_like?
      self.liked_by(liking_user)
      true
    else
      errors.add(:base, "The activity has been archived, you cannot like it anymore")      
      false    
    end
  end

  def unlike_post(liking_user)

    if self.can_like?
      self.unliked_by(liking_user)
      true
    else
      errors.add(:base, "The activity has been archived, you cannot unlike it anymore")      
      false
    end
  end

  def append_comment(comment)
    if comment.save!
      true
    else
      errors.add(:base, "Could not save the comment")
      false
    end
  end

  def complete
    self.status = "finished" unless self.status == "archived"
    self.room.update(status: "finished") unless self.room.status == "archived"
  end

  def archive
    self.status = "archived"
    self.room.update(status: "archived")
  end

  def creator
    if self.activity_id.nil?
      self.user
    else
      u = Activity.find_by(id: self.activity_id)
      if u.nil?
        errors.add(:base, "The shared activity cannot find the source")
      else
        u.user
      end
    end
  end

  def can_vote?
    self.status == "finished"
  end

  def can_share?
    self.status != "archived"
  end

  def can_like?
    self.status != "archived"
  end

  def comments
    self.root_comments
  end

end
