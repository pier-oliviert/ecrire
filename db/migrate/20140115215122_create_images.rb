class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.string :key

      t.references :post

      t.timestamps
    end
  end
end
