class AddTweetToImages < ActiveRecord::Migration
  def change
    add_column :images, :tweet, :string
  end
end
