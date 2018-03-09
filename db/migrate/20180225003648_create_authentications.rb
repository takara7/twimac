class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.string :provider, null: false, default: "twitter"
      t.string :uid, null: false
      t.json :token, null: false

      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :authentications, [:uid, :provider], unique: true
  end
end
