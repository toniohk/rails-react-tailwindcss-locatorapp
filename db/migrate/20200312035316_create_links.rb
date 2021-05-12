class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.references :search, null: false, foreign_key: true
      t.references :surgeon, foreign_key: true
      t.timestamps
    end
  end
end
