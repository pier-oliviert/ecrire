class ConvertMarkdownInPostContent < ActiveRecord::Migration
  def change
    add_column :posts, :compiled_content, :text
  end
end

