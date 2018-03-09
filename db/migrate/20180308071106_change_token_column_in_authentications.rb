class ChangeTokenColumnInAuthentications < ActiveRecord::Migration[5.1]
  def up
    change_column :authentications, :token, :string
    add_column :authentications, :token_secret, :string
  end

  def down
    change_column :authentications, :token, :json
    remove_column :authentications, :token_secret
  end
end
