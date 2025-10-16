class CreateGiftLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :gift_links do |t|
      t.string :token, null: false
      t.boolean :used, default: false, null: false

      t.timestamps
    end
    add_index :gift_links, :token, unique: true
  end
end
