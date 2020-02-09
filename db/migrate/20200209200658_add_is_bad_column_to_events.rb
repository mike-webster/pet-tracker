class AddIsBadColumnToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_bad, :boolean, null: true
  end
end
