class CreateJoinTableRoomUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :rooms, :users, id: false do |t|
      t.belongs_to :room, index:true
      t.belongs_to :user, index:true
      # t.index [:room_id, :user_id]
      # t.index [:user_id, :room_id]
    end
  end
end
