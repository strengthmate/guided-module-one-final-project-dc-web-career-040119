class CreateMovieDirectors < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_directors do |t|
      t.integer :movie_api_id
      t.integer :director_api_id
      t.integer :movie_id
      t.integer :director_id
    end
  end
end
