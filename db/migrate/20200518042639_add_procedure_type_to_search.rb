class AddProcedureTypeToSearch < ActiveRecord::Migration[6.0]
  def change
  	add_column :searches, :procedure_type, :string, array: true, default: '{}'
  end
end
