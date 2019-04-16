class RenameMovieIdAndGenreIdInMoviesAndGenres < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :movie_id, :api_id
    rename_column :genres, :genre_id, :api_id
  end
end
