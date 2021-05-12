class AddColumnAccessToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :access, :string, default: 'private'
  end
end
