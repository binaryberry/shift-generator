class RemoveNameFromWeeks < ActiveRecord::Migration
  def change
    remove_column :weeks, :name, :string
  end
end
