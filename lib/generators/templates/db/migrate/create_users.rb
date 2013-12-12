class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :signup_token
      t.string :password_token
      t.boolean :active
      t.string  :username
      t.datetime :confirmed, :null => true
      t.timestamps
    end
  end
end
