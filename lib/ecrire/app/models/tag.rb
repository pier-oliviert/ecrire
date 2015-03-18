class Tag < ActiveRecord::Base
  def ==(other)
    self.class.table_name == other.class.table_name && self.id == other.id
  end
end
