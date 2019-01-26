class ActivitySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :deadline, :description, :created_at, :status, :shared, :activity_id
  belongs_to :user

  attribute :likes, &:cached_weighted_score

  attribute :followers do |object|
  	object.followers_by_type('User').size
  end

  attribute :image do |object|
  	Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attachment
  end

  attribute :comments #a method

  attribute :shares

  attribute :original

end
