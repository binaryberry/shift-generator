class LinkRolesAndWeeks < ActiveRecord::Migration
  def change
    create_table :weeks_roles, id: false do |t|
      t.belongs_to :week, index: true
      t.belongs_to :role, index: true
    end
  end
end
