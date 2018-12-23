# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar
  #this line uses activestorage to store the files on a local file (for now), attached is added because it is a file

  #followers and following implementarion
  
  acts_as_follower
  #enable the user to use the follow methods
  #it can follow itself if you add the line below


  acts_as_followable
  #enables the user to be followed


  acts_as_votable 
  #permits voting on the user, it works as the rating column
  #TODO: Check if I have to remove it




end
