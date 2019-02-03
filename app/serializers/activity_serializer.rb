class ActivitySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :title, :deadline, :description, :created_at, :status, :shared, :activity_id

  belongs_to :user

  belongs_to :original, record_type: :activity, id_method_name: :original_activity_id, serializer: ActivitySerializer ,if: Proc.new { |record| !record.original_activity.nil? }	

  attribute :likes do |object|
  	object.get_likes.size
  end

  attribute :followers do |object|
  	object.followers_by_type('User').size
  end

  attribute :image do |object|
  	Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attachment
  end

  attribute :comments #a method

  has_many :shares

  #attribute :original, serializer: ActivitySerializer


  


end
