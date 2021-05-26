# frozen_string_literal: true

class AddSuperAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :super_admin, :boolean, default: false
  end
end
