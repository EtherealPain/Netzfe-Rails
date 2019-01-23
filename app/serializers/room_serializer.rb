class RoomSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :name, :created_at, :updated_at
    attributes :messages do |object|
        object.messages.each do |c|
            c.body
            c.id
        end
    end 
    belongs_to :activity    
end
  