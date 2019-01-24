class AddColumnsToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :shared, :boolean, default: false
    add_column :activities, :activity_id, :integer, null: true
  end
end
