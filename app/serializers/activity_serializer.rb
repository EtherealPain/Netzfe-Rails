class ActivitySerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :deadline, :description, :created_at

  attribute :likes do |object|
    object.get_likes.size
  end

  attribute :followers do |object|
  	object.followers_by_type('User').size
  end

end
