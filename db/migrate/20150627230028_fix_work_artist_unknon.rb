class FixWorkArtistUnknon < ActiveRecord::Migration
  def change
    remove_column :works, :artist_unknown
    add_column :works, :artist_unknown, :boolean
  end
end