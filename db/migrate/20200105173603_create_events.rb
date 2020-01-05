class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.bigint :pet_id
      t.string :kind
      t.string :notes
      t.datetime :happened_at
      t.datetime :created_at
    end
    add_foreign_key :events, :pets
  end
end
