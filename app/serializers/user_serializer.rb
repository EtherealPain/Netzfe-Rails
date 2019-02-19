class UserSerializer < ActiveModel::Serializer
  attributes :id, 
  			:avatar, 
  			:date_of_birth,
  			:degree,
  			:email,
  			:first_name,
  			:followers,
			:following,
			:is_follower,
  			:last_name,
  			:participant_in,
  			:phone,
  			:rating,
  			:uid

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
		object.profile_image.url if object.profile_image
  end

  def is_follower
    current_user.following? object
  end
  
end