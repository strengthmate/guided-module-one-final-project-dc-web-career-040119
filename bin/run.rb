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

#ask what the user wants to search by
# after user enters item ask the next criteria
#
puts "Welcome!"
Movie.recommendation

