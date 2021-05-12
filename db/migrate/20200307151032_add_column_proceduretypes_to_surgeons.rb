class AddColumnProceduretypesToSurgeons < ActiveRecord::Migration[6.0]
  def change
    add_column :surgeons, :procedure_types, :string, default: nil
  end
end
