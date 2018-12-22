class AddDegreeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :degree, :string
  end
end
