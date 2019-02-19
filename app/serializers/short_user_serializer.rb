class ShortUserSerializer < ActiveModel::Serializer
  type :user
  attributes :id, :first_name, :last_name, :avatar, :is_follower

  def avatar
  	object.profile_image.url if object.profile_image
  end

  def is_follower
    current_user.following? object
  end
  
end
