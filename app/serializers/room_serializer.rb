class RoomSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :name, :created_at, :updated_at
    has_many :messages 
    belongs_to :activity    
end
  