class AddIndexToImages < ActiveRecord::Migration
  def change
    add_index :images, :ghash, unique: true
  end
end
