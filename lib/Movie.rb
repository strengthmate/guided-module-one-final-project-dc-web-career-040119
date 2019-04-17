class Movie < ActiveRecord::Base
  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :cast_members
  has_many :actors, through: :cast_members


end
