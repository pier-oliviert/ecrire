class AddJavascriptToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :javascript, :text
  end
end
