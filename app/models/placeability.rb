class Placeability < ApplicationRecord
  has_many :works
  scope :not_hidden, ->{where(hide:[nil,false])}

  include NameId

end
