class AddPropertiesToPosts < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION hstore'
    add_column :posts, :properties, :hstore
  end
end
