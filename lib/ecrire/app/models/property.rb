class Property < ActiveRecord::Base
  belongs_to :data, polymorphic: true
  belongs_to :post

  scope :labels, -> {
    where("properties.data_type = 'Label'")
  }
end
