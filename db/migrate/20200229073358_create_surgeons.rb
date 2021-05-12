class CreateSurgeons < ActiveRecord::Migration[6.0]
  def change
    create_table :surgeons do |t|
      t.string :full_name
      t.string :email
      t.string :url
      t.string :suffix
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
