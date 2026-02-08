class CreateWatchLaters < ActiveRecord::Migration[8.1]
  def change
    create_table :watch_laters do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :tmdb_id
      t.string :title
      t.string :poster_path
      t.text :overview
      t.decimal :rating
      t.text :genre_ids
      t.string :release_date

      t.timestamps
    end
  end
end
