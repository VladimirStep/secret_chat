class CreateChatRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_rooms do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :password_digest

      t.timestamps
    end
  end
end
