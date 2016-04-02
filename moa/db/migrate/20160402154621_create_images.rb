class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.integer :ghash

      t.timestamps null: false
    end
  end
end
