class AddDefaultArchivedStatusToUser < ActiveRecord::Migration[5.2]
  def change
	change_column_default :users, :archived, from: nil, to: false
  end
end
