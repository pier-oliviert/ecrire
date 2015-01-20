class AddPreviewToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :compiled_preview_content, :text
    remove_column :posts, :excerpt
    rename_column :posts, :compiled_preview_content, :compiled_excerpt
  end
end

