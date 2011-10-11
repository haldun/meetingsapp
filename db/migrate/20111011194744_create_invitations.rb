class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.belongs_to :user
      t.belongs_to :room
      t.string :name
      t.string :email
      t.integer :status
      t.string :token

      t.timestamps
    end
    add_index :invitations, :user_id
    add_index :invitations, :room_id
    add_index :invitations, :email
    add_index :invitations, :token
  end
end
