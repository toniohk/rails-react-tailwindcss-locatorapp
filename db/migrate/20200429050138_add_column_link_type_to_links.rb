class AddColumnLinkTypeToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :link_type, :string
  end
end
