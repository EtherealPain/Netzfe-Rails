class AddDefaultStatusToActivity < ActiveRecord::Migration[5.2]
  def change
  	change_column_default :activities, :status, from: nil, to: 0
  end
end
