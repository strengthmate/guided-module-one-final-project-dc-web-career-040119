require_relative 'find_movies'

class Director < ActiveRecord::Base

  extend FindMovies::ClassMethods

  has_many :movie_directors
  has_many :movies, through: :movie_directors

end
