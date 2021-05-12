class AddColumnStatusToSurgeons < ActiveRecord::Migration[6.0]
  def change
    add_column :surgeons, :status, :string, default: 'private'
  end
end
