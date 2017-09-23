class AddStatusToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :status, :integer, default: 1
  end
end
