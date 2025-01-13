class AddDateToLists < ActiveRecord::Migration[8.0]
  def change
    add_column :lists, :date, :date
  end
end
