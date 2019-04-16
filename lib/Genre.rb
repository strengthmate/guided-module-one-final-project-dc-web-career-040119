require_relative 'find_movies'

class Genre < ActiveRecord::Base

  extend FindMovies::ClassMethods

  has_many :movie_genres
  has_many :movies, through: :movie_genres

end
