class ChangeRoleTypeInPeople < ActiveRecord::Migration
  def change
    remove_column :people, :roles, :string
    add_column :people, :roles, :string, array: true
  end
end
