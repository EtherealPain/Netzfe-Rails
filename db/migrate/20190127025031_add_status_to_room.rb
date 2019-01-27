class AddStatusToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :status, :string, default: 'open'
  end
end
