class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone_number
      t.string :fax_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
