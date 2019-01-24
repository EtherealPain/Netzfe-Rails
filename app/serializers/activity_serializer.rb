class ActivitySerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :deadline, :description, :created_at, :shared, :activity_id

  attribute :likes do |object|
    object.get_likes.size
  end

  attribute :followers do |object|
  	object.followers_by_type('User').size
  end

  attribute :image do |object|
  	Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attachment
  end

  attribute :comments do |object|
  	object.root_comments
  end

end
