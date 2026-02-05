class CreatePreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.text :favorite_genres
      t.integer :min_year
      t.integer :max_year
      t.decimal :min_rating
      t.string :preferred_language

      t.timestamps
    end
  end
end
