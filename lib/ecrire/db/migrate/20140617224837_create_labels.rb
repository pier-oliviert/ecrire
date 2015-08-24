class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|

      t.string :name, null: false
      t.timestamps null: false

    end
    add_index :labels, :name, unique: false
  end
end

