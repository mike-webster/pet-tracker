class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :pass_hash

      t.timestamps
    end

    add_column :pets, :user_id, :bigint
  end
end
