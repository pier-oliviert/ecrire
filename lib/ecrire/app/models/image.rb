class Image < ActiveRecord::Base
  belongs_to :post

  scope :favorites, lambda { where('images.favorite is true') }
end
