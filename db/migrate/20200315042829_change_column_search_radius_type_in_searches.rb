class ChangeColumnSearchRadiusTypeInSearches < ActiveRecord::Migration[6.0]
  def up
    change_column :searches, :search_radius, :int, using: 'search_radius::int'
  end

  def down
    change_column :searches, :search_radius, :string, using: 'search_radius::string'
  end
end
