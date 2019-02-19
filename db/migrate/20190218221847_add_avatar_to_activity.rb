class AddAvatarToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :avatar, :string, default: ''
  end
end
