class CreateAbtests < ActiveRecord::Migration
  def change
    create_table :abtests do |t|

      t.timestamps
    end
  end
end
