class CreateChatAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_accesses do |t|
      t.references :user, foreign_key: true
      t.references :chat_room, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
