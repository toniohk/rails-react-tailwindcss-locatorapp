class RemoveColumnRoleFromSearches < ActiveRecord::Migration[6.0]
  def change
    remove_column :searches, :role, :string
  end
end
