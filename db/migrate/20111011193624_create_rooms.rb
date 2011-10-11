class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.belongs_to :owner
      t.string :name
      t.string :topic
      t.string :token

      t.timestamps
    end
    add_index :rooms, :owner_id
    add_index :rooms, :token
  end
end
