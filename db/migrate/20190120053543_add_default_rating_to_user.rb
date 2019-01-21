class AddDefaultRatingToUser < ActiveRecord::Migration[5.2]
  def change
  	change_column_default :users, :rating, from: nil, to: 0
  end
end
