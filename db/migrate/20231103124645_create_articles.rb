class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.references :author, foreign_key: { to_table: :users }
      t.text :content
      t.boolean :comments_enabled
      t.datetime :publish_by

      t.timestamps
    end
  end
end
