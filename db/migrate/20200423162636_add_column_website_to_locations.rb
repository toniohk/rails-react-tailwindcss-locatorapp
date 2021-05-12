class AddColumnWebsiteToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :website, :string
  end
end
