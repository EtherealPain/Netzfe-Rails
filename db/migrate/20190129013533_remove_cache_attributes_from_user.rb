class RemoveCacheAttributesFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :cached_votes_total, :integer, default: 0
    remove_column :users, :cached_votes_score, :integer, default: 0
    remove_column :users, :cached_votes_up, :integer, default: 0
    remove_column :users, :cached_votes_down, :integer, default: 0
    remove_column :users, :cached_weighted_score, :integer, default: 0 
    remove_column :users, :cached_weighted_total, :integer, default: 0
    remove_column :users, :cached_weighted_average, :float, default: 0.0

  end
end
