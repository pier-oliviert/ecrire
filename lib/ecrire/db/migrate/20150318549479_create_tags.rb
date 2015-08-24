class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :tags, :name, unique: true

    add_column :posts, :tags, :integer, array: true, defaut: []
  end
end
