class UserFullSerializer < ActiveModel::Serializer
  attributes :id, 
  			:avatar, 
  			:date_of_birth,
  			:degree,
  			:email,
  			:first_name,
  			:followers,
  			:following,
  			:last_name,
  			:participant_in,
  			:phone,
  			:rating,
  			:uid

  has_many :follower_list, serializer: ShortUserSerializer
  has_many :following_list, serializer: ShortUserSerializer



  def follower_list
  	object.user_followers
  end

  def following_list
  	object.following_users
  end

  def followers
  	object.count_user_followers
  end

  def following
  	object.following_users_count 
  end

  def participant_in
  	object.following_activities_count 
  end

  def rating
  	object.cached_weighted_average
  end

  def avatar
  	Rails.application.routes.url_helpers.rails_blob_path(object.avatar, only_path: true) if object.avatar.attachment
  end
end