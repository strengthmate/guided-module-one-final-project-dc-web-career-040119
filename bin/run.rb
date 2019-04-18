require_relative '../config/environment'
require "pry"

# Store inputs for this session
PREVIOUSLY_ENTERED = {
  'Genre' => [],
  'Actor' => []
}.freeze

SELECTION = {
  movie_list: [],
  prev_movie_list: []
}

puts "Welcome!"
Movie.recommendation

