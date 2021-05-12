class FixColumnNameAccessInLocations < ActiveRecord::Migration[6.0]
  def change
    rename_column :locations, :access, :status
  end
end
