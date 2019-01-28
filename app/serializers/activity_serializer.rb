class ActivitySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :deadline, :description, :created_at, :status, :shared
  belongs_to :user

  belongs_to :original, record_type: :activity, if: Proc.new { |record| !record.original.nil? }	

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
