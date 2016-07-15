class RemovePersonIdFromRoles < ActiveRecord::Migration
  def change
    remove_column :roles, :person_id, :integer
  end
end
