class FollowersSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :user

end
