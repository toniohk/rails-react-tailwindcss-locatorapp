class CreateSearch < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :search_radius
      t.string :procedure_types
      t.string :zip
      t.string :area_of_discomfort
      t.string :role
      
      t.timestamps
    end
  end
end
