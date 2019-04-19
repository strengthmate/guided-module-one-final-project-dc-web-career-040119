require_relative "find_movies"

class Movie < ActiveRecord::Base

  extend FindMovies::ClassMethods

  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :cast_members
  has_many :actors, through: :cast_members
  has_many :movie_directors
  has_many :directors, through: :movie_directors

  def self.find_movie_by_keyword
    puts "Enter a keyword"
    input = gets.strip
    50.times {puts ""}
    keyword = input.downcase
    movies_with_keyword = Movie.where("description LIKE ?", "%#{keyword}%")

    if movies_with_keyword.empty? || keyword.empty?
      puts "Sorry, that keyword didn't return any matches"
      puts 'or type "back" to try a different criteria'
      find_movie_by_keyword
      return
    elsif keyword == 'back'
      recommendation
      return
    end
    PREVIOUSLY_ENTERED["Keyword"] << input

    if SELECTION[:movie_list].empty?
      SELECTION[:movie_list] = movies_with_keyword
      output_entered
      recommendation
    else
      SELECTION[:prev_movie_list] = SELECTION[:movie_list]
      SELECTION[:movie_list] = SELECTION[:movie_list].select do |movie|
        movie.description.include?(keyword)
      end
      if SELECTION[:movie_list].empty?

        SELECTION[:movie_list] = SELECTION[:prev_movie_list]
        too_many_keywords
      else
        output_entered
        recommendation
      end
    end

  end

  def self.too_many_keywords
    puts "You have entered too many keywords.".colorize(:red)
    PREVIOUSLY_ENTERED['Keyword'].pop unless PREVIOUSLY_ENTERED['Keyword'].empty?
    movie_recommendations
  end

end
