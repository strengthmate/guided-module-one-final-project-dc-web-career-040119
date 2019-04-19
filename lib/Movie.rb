require_relative "find_movies"

class Movie < ActiveRecord::Base

  extend FindMovies::ClassMethods

  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :cast_members
  has_many :actors, through: :cast_members
  has_many :movie_directors
  has_many :directors, through: :movie_directors

  # Prompts user to search for movies keywords
  # searches database and sets input as a variable
  # selects movies in which the keyword exists in the description
  # Adds search term to the PREVOUSLY_ENTERED array
  def self.find_movie_by_keyword
    puts "Enter a keyword".colorize(:light_magenta)
    puts 'or type "back" to try a different criteria'.colorize(:light_magenta)
    input = gets.strip
    90.times {puts ""}
    keyword = input.downcase
    movies_with_keyword = Movie.where("description LIKE ?", "%#{keyword}%")

    if movies_with_keyword.empty? || keyword.empty?
      puts "Sorry, that keyword didn't return any matches".colorize(:red)
      puts "Please enter another keyword".colorize(:light_magenta)
      puts 'or type "back" to try a different criteria'.colorize(:light_magenta)
      find_movie_by_keyword
      return
    elsif keyword == 'back'
      recommendation
      return
    end

    PREVIOUSLY_ENTERED["Keyword"] << input unless PREVIOUSLY_ENTERED["Keyword"].include?(input)

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

  # removes keyword that user has entered #if there are no movie descriptions that have the combination of keywords entered by the user
  def self.too_many_keywords
    puts "You have entered too many keywords.".colorize(:red)
    PREVIOUSLY_ENTERED['Keyword'].pop unless PREVIOUSLY_ENTERED['Keyword'].empty?
    movie_recommendations
  end
end
