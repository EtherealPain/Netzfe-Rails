class ActivitySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :title, :deadline, :description, :created_at, :status, :shared, :activity_id

  belongs_to :original, record_type: :activity, id_method_name: :original_activity_id, serializer: ActivitySerializer ,if: Proc.new { |record| !record.original_activity.nil? }	

  attribute :user, serializer: UserSimpleSerializer

  attribute :likes do |object|
  	object.get_likes.size
  end

  attribute :is_liked do |object, params|
  	object.voted_on_by? params[:current_user]
  end

  attribute :is_suscribed do |object, params|
  	params[:current_user].following? object
  end


  attribute :subscribers do |object|
  	object.followers_by_type('User').size
  end

  attribute :comments_number 

  attribute :image do |object|
  	Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attachment
  end

  attribute :comments #a method

  has_many :shares

  #attribute :original, serializer: ActivitySerializer


  


end
