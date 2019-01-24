class MessageSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :body
    belongs_to :user
end
