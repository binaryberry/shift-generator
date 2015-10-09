class AddStartDateToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :start_date, :date
    remove_column :weeks, :description, :text
  end
end
