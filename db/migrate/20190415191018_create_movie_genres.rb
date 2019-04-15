class CreateMovieGenres < ActiveRecord::Migration[5.2]
  def change
    create_table do |t|
      t.integer :movie_id
      t.integer :genre_id
    end
  end
end
