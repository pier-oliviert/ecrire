class AddPropertiesToPosts < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'
    add_column :posts, :properties, :hstore
  end
end
