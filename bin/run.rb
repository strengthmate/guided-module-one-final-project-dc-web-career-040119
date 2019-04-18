require_relative '../config/environment'
require "pry"

# Store inputs for this session
PREVIOUSLY_ENTERED = {
  'Genre' => [],
  'Actor' => [],
  'Keyword' => []
}.freeze

SELECTION = {
  movie_list: [],
  prev_movie_list: []
}

def recommendation
  puts "What category would you like to search by?"
  puts ""
  puts "1. Actors"
  puts "2. Genres"
  puts "3. Keywords"
  puts "4. Done"
  puts "_" * 60
  puts ""


  case gets.strip.downcase
  when "1", "actors"
    Actor.new_get_movie_selection
  when "2", "genres"
    Genre.new_get_movie_selection
  when "3", "keywords"
    Movie.find_movie_by_keyword
  when "4", "done"
    Movie.movie_recommendations
  else
    puts "Input error! Try again."
    recommendation
  end
end

def reset
  SELECTION[:movie_list] = []
  PREVIOUSLY_ENTERED.each { |k, v| v.clear }
end

def ending_prompt
  puts ""
  puts "Would you like to get a new recommendation? "
  puts ""
  puts "1. Yes"
  puts "2. No"
  puts "_" * 60

  case gets.strip.downcase
  when "1" , "yes", 'y'
    reset
    recommendation
  when "2", "no", "n"
    puts ""
    puts "Enjoy the movie!".colorize(:light_magenta)
  else
    puts "Input error! Try again."
    ending_prompt
  end
end

puts "Welcome!"
recommendation

