class AddFavoriteFlagToImage < ActiveRecord::Migration
  def change
    add_column :images, :favorite, :boolean
  end
end
