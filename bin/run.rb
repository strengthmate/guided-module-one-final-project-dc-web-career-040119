require_relative '../config/environment'
require "pry"

puts "Enter a movie genre"
genre_selection = gets.strip.downcase
movie_list = Genre.find_movies_by_genre_name(genre_selection)
Genre.narrow_movie_selection_by_genre(movie_list)
