class AddPhoneToSurgeons < ActiveRecord::Migration[6.0]
  def change
    add_column :surgeons, :phone, :string
  end
end
