class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :lang, null: false, default: "en"
      t.references :user, null: false

      t.timestamps
    end
  end
end
