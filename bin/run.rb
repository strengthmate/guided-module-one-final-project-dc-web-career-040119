require_relative '../config/environment'
require "pry"
require 'themoviedb-api'

# Authenticate TMDB API
Tmdb::Api.key("9a306747f13ec661784ee120bacdd6fc")

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
    movie_recommendations
  else
    puts "Input error! Try again."
    recommendation
  end
end

# Print all inputs for this session
def output_previously_entered
  PREVIOUSLY_ENTERED.each do |key,value|
    puts "#{key}: #{value.join(", ")}".colorize(:yellow)
  end
end

# Output movie recommendations
def movie_recommendations
  puts "Here are your results for:".colorize(:yellow)
  output_previously_entered
  puts (SELECTION[:movie_list].each_with_index.map { |movie, i| "#{i + 1}. #{movie.name}".colorize(:green)})
  ask_for_movie_info
  # ending_prompt
end

def ask_for_movie_info
  #show description rating reviews date cast trailer link
  puts ""
  puts "Select a movie that you would like to learn more about,"
  puts 'or type "done" to get more recommendations.'
  puts ""

  input = gets.strip.downcase
  if input == 'done'
    ending_prompt
  else
    movie_selection = SELECTION[:movie_list].each_with_index.find do |movie, i|
      input == movie.name.downcase || input.to_i == i + 1
    end
    if movie_selection.empty?
      puts "Sorry, that input was not recognized"
      ask_for_movie_info
      return
    else
      movie_info(movie_selection[0])
    end
  end

end

def movie_info(movie)
  puts "Here is some information about #{movie.name}"
  puts ""
  puts "Website: #{Tmdb::Movie.detail(movie.api_id).homepage}"
  puts ""
  puts "Genres: ".colorize(:yellow)
  Tmdb::Movie.detail(movie.api_id).genres.each { |genre| print "#{genre.name} ,"}
  puts ""
  puts "Description:".colorize(:yellow)
  puts movie.description
  puts ""
  puts "Directed by:".colorize(:yellow)
  Tmdb::Movie.director(movie.api_id).each { |director| print "#{director.name.colorize(:green)}, " } # todo: remove final comma
  puts ""
  puts "Released: #{Tmdb::Movie.detail(movie.api_id).release_date[0..3]}"
  puts ""
  puts "Cast:".colorize(:yellow)
  Tmdb::Movie.cast(movie.api_id).each { |actor| print "#{actor.name.colorize(:green)} as #{actor.character}, " }
  puts ""
  puts
  puts "Reviews:"
  Tmdb::Movie.reviews(movie.api_id).results[0..2].each_with_index {|r, i| puts "Review #{i+1}.".colorize(:yellow) + "#{r.content}\n***\n" }
  puts ""
  puts 'Type "done" to return to your results'
  back_out_movie_info
end

def back_out_movie_info
  input = gets.strip.downcase
  if input == 'done'
    movie_recommendations
  else
    puts 'Input not recognized: Type "done" to return to your results'
    back_out_movie_info
  end
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

def reset
  SELECTION[:movie_list] = []
  PREVIOUSLY_ENTERED.each { |k, v| v.clear }
end

puts "Welcome!"
recommendation

