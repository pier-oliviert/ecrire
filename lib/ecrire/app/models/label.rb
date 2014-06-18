class Label < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_name, :against => :name

  validates_presence_of :name
end
