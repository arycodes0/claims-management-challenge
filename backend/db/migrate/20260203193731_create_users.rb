class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: "staff"
      t.string :authentication_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :authentication_token, unique: true
  end
end
