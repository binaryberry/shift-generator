class AddActiveColumnToPeople < ActiveRecord::Migration
  def change
    add_column :people, :active, :boolean
    add_index :people, :active
  end
end
