class CreateMetaAttributes < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.references :post
      t.references :data, polymorphic: true
    end
  end
end
