class Movie < ActiveRecord::Base
  has_many :movie_genres
  has_many :genres, through: :movie_genres

  # select_genre = gets.strip.capitalize

  # def self.find_movies_by_genre_name
  #   self.all.select do |movie_object|
  #     movie_object.genres.include?(Genre.find_by(name:select_genre))
  #   end
  # end

end
