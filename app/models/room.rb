class Room < ApplicationRecord
    has_and_belongs_to_many :users #One Conversation has or can has many users
    has_many :messages, dependent: :destroy
    belongs_to :activity, dependent: :destroy
end
