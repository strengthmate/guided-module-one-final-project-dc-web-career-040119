class AddLocalIdsToMovieGenres < ActiveRecord::Migration[5.2]
  def change
    rename_column :movie_genres, :movie_id, :movie_api_id
    rename_column :movie_genres, :genre_id, :genre_api_id
    add_column :movie_genres, :movie_id, :integer
    add_column :movie_genres, :genre_id, :integer
  end
end
