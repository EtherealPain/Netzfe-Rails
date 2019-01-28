class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :last_name, :first_name, :date_of_birth, :degree, :phone, :rating, :email, :uid

  attribute :rating, &:cached_weighted_score

  attribute :avatar do |object|
  	Rails.application.routes.url_helpers.rails_blob_path(object.avatar, only_path: true) if object.avatar.attachment
  end

  attribute :followers do |object|
  	object.count_user_followers 
  end

  attribute :following do |object|
  	object.following_users_count 
  end

  attribute :participant_in do |object|
  	object.following_activities_count 
  end

  attribute :follower_list do |object|
  	object.followers
  end
end
