class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :fullname
      t.string :email
      t.string :password_digest
      t.boolean :is_admin
      t.boolean :is_banned

      t.timestamps
    end
  end
end
