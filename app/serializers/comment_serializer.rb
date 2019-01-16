class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :user, :body, :created_at, :updated_at
end
