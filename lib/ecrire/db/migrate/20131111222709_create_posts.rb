class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

      t.string :title, null: false
      t.string :slug, null: false
      t.text :content
      t.text :stylesheet

      t.datetime :published_at
      t.timestamps

    end
    add_index :posts, :title, unique: true
  end
end
