class Source < ActiveRecord::Base
  scope :not_hidden, ->{where(hide:[nil,false])}
  default_scope ->{order(:name)}
  include NameId
end
