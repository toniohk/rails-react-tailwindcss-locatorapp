class AddProcedureTypeArrayToSurgeons < ActiveRecord::Migration[6.0]
  def change
  	add_column :surgeons, :procedure_types_array, :string, array: true, default: '{}'
  end
end
