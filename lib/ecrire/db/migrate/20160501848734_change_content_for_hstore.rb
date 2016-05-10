class ChangeContentForHstore < ActiveRecord::Migration
  class Post < ActiveRecord::Base
  end

  def up
    change_table :posts do |t|
      t.column :new_content, :hstore, default: {raw: '', html: ''}
    end

    Post.all.each do |p|
      p.new_content['raw'] = p.content
      p.new_content['html'] = p.compiled_content
      p.save
    end

    change_table :posts do |t|
      t.remove :compiled_content
      t.remove :content
      t.rename :new_content, :content
    end
  end

  def down
    change_table :posts do |t|
      t.text :compiled_content
      t.text :new_content
    end

    Post.each do |p|
      p.content = p.new_content['raw']
      p.compiled_content = p.new_content['html']
      p.save
    end

    change_table :posts do |t|
      t.remove :content
      t.rename :new_content, :content
    end
  end
end

