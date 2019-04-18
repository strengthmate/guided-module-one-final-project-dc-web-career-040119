require_relative 'find_movies'

class Movie < ActiveRecord::Base

  extend FindMovies::ClassMethods

  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :cast_members
  has_many :actors, through: :cast_members

  def self.recommendation
    puts "What category would you like to search by?"
    puts ""
    puts "1. Actors"
    puts "2. Genres"
    puts "3. Done"

    selection = gets.strip.downcase
    case selection
    when "1", "actors"
      Actor.new_get_movie_selection
    when "2", "genres"
      Genre.new_get_movie_selection
    when "3", "done"
      movie_recommendations
    else
      puts "Input error! Try again."
      self.recommendation
    end
  end

end
