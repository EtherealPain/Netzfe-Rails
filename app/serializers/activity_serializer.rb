class ActivitySerializer < ActiveModel::Serializer
  attributes :id,
           :title,
           :description,
           :category,
           :image,
           :deadline,
           :created_at,
           :like_number,
           :comment_number,
           :shared_number,
           :is_subscribed,
           :is_liked,
           :is_shared,
           :status,
           :original_id

  has_one :creator, if: :is_shared, serializer: ShortUserSerializer
             

<<<<<<< HEAD
  belongs_to :user, serializer: ShortUserSerializer
=======
  
  attributes :user do |activity|
    { user_id: activity.user.id, first_name: activity.user.first_name, last_name: activity.user.last_name}
  end
>>>>>>> origin/search


  def title
    object.shared? ? object.original.title : object.title
  end

  def description
    object.shared? ? object.original.description : object.description
  end

  def category
    object.shared? ? object.original.category.description :  object.category.description
  end

  def image
    if object.shared?
      Rails.application.routes.url_helpers.rails_blob_path(object.original.image, only_path: true) if object.original.image.attachment
    else
      Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attachment
    end
  end

  def deadline
    object.shared? ? object.original.deadline : object.deadline
  end

  def like_number
    object.shared? ? object.original.get_likes.size : object.get_likes.size
  end

  def is_subscribed
    if object.shared?
      current_user.following? object.original
    else
      current_user.following? object
    end
  end

  def is_liked
    if object.shared?
      object.original.voted_on_by? current_user
    else
      object.voted_on_by? current_user
    end
    
  end

  def comment_number
    if object.shared?
      object.original.root_comments.size
    else
      object.root_comments.size
    end
    
  end

  def shared_number
    if object.shared
      object.original.shares.size
    else
      object.shares.size
    end
    
  end

  def is_shared
    object.shared?
  end

  def original_id
    if object.shared?
      object.original.id      
    end
  end



end
