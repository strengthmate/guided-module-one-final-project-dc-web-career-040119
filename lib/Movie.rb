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
    puts "_" * 86
    puts ""


    case gets.strip.downcase
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

  def self.reset
    SELECTION.each { |k, v| v.clear }
    PREVIOUSLY_ENTERED.each { |k, v| v.clear }
  end

  def self.ending_prompt
    puts ""
    puts "Would you like to get a new recommendation? "
    puts ""
    puts "1. Yes"
    puts "2. No"
    puts "_" * 86

    case gets.strip.downcase
    when "1" , "yes", 'y'
      self.recommendation
    when "2", "no", "n"
      puts ""
      puts "Enjoy the movie!".colorize(:light_magenta)
    else
      puts "Input error! Try again."
      self.recommendation
    end
  end

end
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
    puts "_" * 60
    puts ""


    case gets.strip.downcase
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

  def self.reset
    SELECTION[:movie_list] = []
    PREVIOUSLY_ENTERED.each { |k, v| v.clear }
  end

  def self.ending_prompt
    puts ""
    puts "Would you like to get a new recommendation? "
    puts ""
    puts "1. Yes"
    puts "2. No"
    puts "_" * 60

    case gets.strip.downcase
    when "1" , "yes", 'y'
      reset
      self.recommendation
    when "2", "no", "n"
      puts ""
      puts "Enjoy the movie!".colorize(:light_magenta)
    else
      puts "Input error! Try again."
      self.ending_prompt
    end
  end

end
