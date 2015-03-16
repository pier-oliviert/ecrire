class MoveLabelsToTitles < ActiveRecord::Migration
  class Title < ActiveRecord::Base
    belongs_to :post
  end

  class Post < ActiveRecord::Base
  end

  def change
    rename_table :labels, :titles

    add_column :titles, :slug, :string, index: true
    change_column :titles, :name, unique: true, null: false
    add_reference :titles, :post, index: true

    Post.all.each do |post|
      Title.create do |t|
        t.slug = post.slug
        t.name = post.title
        t.post = post
      end
    end

    remove_column :posts, :title
    remove_column :posts, :slug
  end
end
