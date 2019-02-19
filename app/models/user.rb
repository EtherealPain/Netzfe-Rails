# frozen_string_literal: true
class User < ActiveRecord::Base
  include PgSearch #this is to search
  pg_search_scope :search_by_full_name, :against => [:first_name, :last_name] #search register by first or last name

  has_and_belongs_to_many :rooms, dependent: :destroy #one user can have many conversations
  
  mount_base64_uploader :profile_image, ImageUploader, file_name: -> (u) { u.first_name }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  
  #this line uses activestorage to store the files on a local file (for now), attached is added because it is a file
  has_one_attached :avatar
  
  has_many :activities, dependent: :destroy #if user is deleted your activities too
  
  #followers and following implementarion
  acts_as_follower
  #enable the user to use the follow methods
  #it can follow itself if you add the line below
  #it is also used to follow the activity
  acts_as_followable
  #enables the user to be followed
  acts_as_votable 
  #permits voting on the user, it works as the rating column

  validate :date_of_birth_validation

   def date_of_birth_validation
    if will_save_change_to_date_of_birth? && date_of_birth.present? && self.date_of_birth > Date.today - 15.years
     errors.add(:date_of_birth, "user must be above 15 years of age!")
    end
  end



  def archive_user
    self.archived = true
  
    self.activities.each do |c|
      c.update(status: "archived") 
      c.room.update(status: "archived")
    end

  end

  def rating
    self.weighted_score
  end


  
end
