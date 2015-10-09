class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :week_id
      t.integer :person_id
      t.string :role
      t.timestamps null: false
    end
  end
end
