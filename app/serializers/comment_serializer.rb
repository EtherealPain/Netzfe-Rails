class CommentSerializer < ActiveModel::Serializer
  attributes :id,
  			 :body, 
  			 :created_at,
  			 :updated_at,
  			 :user_id,
  			 :user_fullname
  def user_id
  	object.user.id
  end
  def user_fullname
  	"#{object.user.first_name} #{object.user.last_name}" 
  end
  
end
