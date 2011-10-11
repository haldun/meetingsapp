class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :room
      t.belongs_to :user
      t.string :role

      t.timestamps
    end
    add_index :memberships, :room_id
    add_index :memberships, :user_id
    add_index :memberships, :role
  end
end
