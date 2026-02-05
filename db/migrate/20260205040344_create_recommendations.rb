class CreateRecommendations < ActiveRecord::Migration[8.1]
  def change
    create_table :recommendations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :tmdb_id
      t.string :title
      t.string :poster_path
      t.text :overview
      t.decimal :rating
      t.boolean :watched

      t.timestamps
    end
  end
end
