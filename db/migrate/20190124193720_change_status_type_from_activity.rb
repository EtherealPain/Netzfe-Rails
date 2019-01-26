class ChangeStatusTypeFromActivity < ActiveRecord::Migration[5.2]
  def change
  	remove_column :activities, :status, :integer
  	add_column :activities, :status, :string
  	change_column_default :activities, :status, from: nil, to: "open"
  end
end
