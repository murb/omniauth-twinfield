# frozen_string_literal: true

class AddLocalityGeonameIdToWorks < ActiveRecord::Migration
  def change
    add_column :works, :locality_geoname_id, :integer
  end
end
