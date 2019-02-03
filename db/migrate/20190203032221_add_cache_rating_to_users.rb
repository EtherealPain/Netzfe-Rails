class AddCacheRatingToUsers < ActiveRecord::Migration[5.2]
  def change

  	change_table :users do |t|
      t.integer :cached_weighted_score, default: 0
      t.integer :cached_weighted_total, default: 0
      t.float :cached_weighted_average, default: 0.0
    end
  end
end
