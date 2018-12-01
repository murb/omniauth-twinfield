class Owner < ApplicationRecord
  include NameId, Hidable,CollectionOwnable

  has_many :works
  belongs_to :collection, optional: false

end