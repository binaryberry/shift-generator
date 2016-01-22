class AddTeamToPeople < ActiveRecord::Migration
  def change
    add_column :people, :team, :string
    add_index :people, :team
  end
end
