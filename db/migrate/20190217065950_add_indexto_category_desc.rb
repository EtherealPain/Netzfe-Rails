class AddIndextoCategoryDesc < ActiveRecord::Migration[5.2]
  def change
  	add_index :categories, :description, unique: true
  end
end
