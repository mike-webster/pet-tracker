class UpdateColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :pass_hash, :password_digest
  end
end
