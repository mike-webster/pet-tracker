class CreatePets < ActiveRecord::Migration[5.2]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :kind
      t.string :breed
      t.datetime :birthday

      t.timestamps
    end
  end
end
