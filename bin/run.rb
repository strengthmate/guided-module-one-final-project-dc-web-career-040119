require_relative '../config/environment'
require "pry"
require 'themoviedb-api'

# Authenticate TMDB API
Tmdb::Api.key("9a306747f13ec661784ee120bacdd6fc")

# Store inputs for this session
PREVIOUSLY_ENTERED = {
  'Genre' => [],
  'Actor' => [],
  'Director' => [],
  'Keyword' => []
}.freeze

#stores results from current selected criteria and results from previously entered criteria
SELECTION = {
  movie_list: [],
  prev_movie_list: []
}

#Initial display #when starting the program
def welcome
  90.times {puts ""}
  puts "Welcome to".colorize(:light_magenta)
  a = Artii::Base.new :font => 'slant'
  puts a.asciify('MoviRecs').colorize(:light_magenta)
  puts 'Press "Enter" to begin'.colorize(:light_magenta)
  gets
  90.times {puts ""}
  recommendation
end

#prompts user to choose a search category and directs to the method for the search category
def recommendation
  puts "By what category would you like to search?".colorize(:light_magenta)
  puts ""
  puts "1. Genre".colorize(:yellow)
  puts "2. Actor".colorize(:yellow)
  puts "3. Director".colorize(:yellow)
  puts "4. Keyword".colorize(:yellow)
  puts "5. Done".colorize(:yellow)

  input = gets.strip.downcase
  90.times {puts ""}
  case input
  when "1", "genre"
    Genre.new_get_movie_selection
  when "2", "actor"
    Actor.new_get_movie_selection
  when "3", "director"
    Director.new_get_movie_selection
  when "4", "keyword"
    Movie.find_movie_by_keyword
  when "5", "done"
    movie_recommendations
  else
    puts "Input error! Try again.".colorize(:red)
    recommendation
  end
end

#prints previously entered search criteria #while user determines the next selection
def output_entered
  PREVIOUSLY_ENTERED.each do |key,value|
    puts "#{key}: #{value.join(", ")}".colorize(:yellow) unless value.empty?
  end
  puts ""
end

# Output movie recommendations
def movie_recommendations
  puts "Here are your results for:".colorize(:light_magenta)
  puts ""
  output_entered
  puts (SELECTION[:movie_list].each_with_index.map { |movie, i| "#{i + 1}. #{movie.name}".colorize(:green)})
  ask_for_movie_info
end

#Allows user to select a movie from the results
def ask_for_movie_info
  #show description rating reviews date cast trailer link
  puts ""
  puts "Select a movie that you would like to learn more about,".colorize(:light_magenta)
  puts 'type "back" to try a different search criteria,'.colorize(:light_magenta)
  puts 'or type "done" to get more recommendations.'.colorize(:light_magenta)
  puts ""

  input = gets.strip.downcase
  90.times {puts ""}

  if input == 'done'
    ending_prompt
  elsif input == 'back'
    recommendation
  elsif SELECTION[:movie_list].include?(input) || input.to_i.between?(1, SELECTION[:movie_list].length)
    movie_selection = SELECTION[:movie_list].each_with_index.find do |movie, i|
      input == movie.name.downcase || input.to_i == i + 1
    end
    movie_info(movie_selection[0])
  else
    puts "Sorry, that input was not recognized".colorize(:red)
    movie_recommendations
    ask_for_movie_info
  end
end

#displays info about the selected movie
def movie_info(movie)
  puts ""
  puts "Here is some information about #{movie.name}".colorize(:light_magenta)
  puts ""
  puts "Website: ".colorize(:yellow)
  puts Tmdb::Movie.detail(movie.api_id).homepage unless Tmdb::Movie.detail(movie.api_id).homepage.nil?
  puts ""
  puts "Genres: ".colorize(:yellow)
  puts Tmdb::Movie.detail(movie.api_id).genres.map { |genre| genre.name}.join(", ")
  puts ""
  puts "Description:".colorize(:yellow)
  puts movie.description
  puts ""
  puts "Directed by:".colorize(:yellow)
  puts Tmdb::Movie.director(movie.api_id).map { |director| director.name }.join(", ")# todo: remove final comma
  puts ""
  puts "Released: ".colorize(:yellow)
  puts Tmdb::Movie.detail(movie.api_id).release_date[0..3]
  puts ""
  puts "Cast:".colorize(:yellow)
  Tmdb::Movie.cast(movie.api_id).each_with_index do |actor, i|
    print "#{actor.name.colorize(:green)} as #{actor.character}, "
    puts "" if (i + 1)  % 3 == 0
  end

  puts ""
  puts ""
  puts "Reviews:".colorize(:yellow)
  Tmdb::Movie.reviews(movie.api_id).results[0..2].each_with_index {|r, i| puts "Review #{i+1}. \n".colorize(:green) + "#{r.content}\n***\n" }
  puts ""

  back_out_movie_info
end

#Enables user to press "Enter" to return to movie results #while movie info is on screen
def back_out_movie_info
  puts 'Press "Enter" to return to your results'.colorize(:light_magenta)
  gets
  90.times {puts ""}
  movie_recommendations
end

#Displays #when user types 'done'. Allows user to either get a new recommendation or end the program
def ending_prompt
  puts ""
  puts "Would you like to get a new recommendation? ".colorize(:light_magenta)
  puts ""
  puts "1. Yes".colorize(:yellow)
  puts "2. No".colorize(:yellow)

  input = gets.strip.downcase
  90.times {puts ""}

  case input
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

#Initializes selection and previously entered constants #when user tries to do a new search
def reset
  SELECTION[:movie_list] = []
  PREVIOUSLY_ENTERED.each { |_, category| category.clear }
end

#start the program
welcome
