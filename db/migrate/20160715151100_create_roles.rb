class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :active
      t.integer :person_id

      t.timestamps null: false
    end
    add_index :roles, :person_id
  end
end
