class AddUserTimezone < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :timezone, :string, null: true
  end
end
