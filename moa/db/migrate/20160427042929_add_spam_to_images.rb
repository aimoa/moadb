class AddSpamToImages < ActiveRecord::Migration
  def change
    add_column :images, :spam, :boolean, :default => false
  end
end
