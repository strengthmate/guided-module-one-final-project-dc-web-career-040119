require_relative '../config/environment'
require "pry"


movie_list = Genre.find_movies_by_input

Genre.narrow_movie_selection(movie_list: movie_list)
# Genre.narrow_movie_selection_by_genre(movie_list)
