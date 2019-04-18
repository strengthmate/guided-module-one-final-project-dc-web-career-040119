require_relative "find_movies"

class Movie < ActiveRecord::Base

  extend FindMovies::ClassMethods

  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :cast_members
  has_many :actors, through: :cast_members

  def self.find_movie_by_keyword
    puts "Enter a keyword"
    keyword = gets.strip
    PREVIOUSLY_ENTERED["Keyword"] << keyword
    keyword.downcase!
    movies_with_keyword = Movie.where("description LIKE ?", "%#{keyword}%")

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
        too_many
      else
        output_entered
        recommendation
      end
    end

  end

end
