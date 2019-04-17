require_relative 'find_movies'

class Actor < ActiveRecord::Base

  extend FindMovies::ClassMethods

  has_many :cast_members
  has_many :movies, through: :cast_members


end
