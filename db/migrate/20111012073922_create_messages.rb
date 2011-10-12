class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :room
      t.belongs_to :author
      t.string :type
      t.text :content

      t.timestamps
    end
    add_index :messages, :room_id
    add_index :messages, :author_id
  end
end
