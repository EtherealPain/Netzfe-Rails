class AddActivityToRooms < ActiveRecord::Migration[5.2]
  def change
    add_reference :rooms, :activity, foreign_key: true
  end
end
