class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :author, foreign_key: { to_table: :users }
      t.text :content

      t.timestamps
    end
  end
end
