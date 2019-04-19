module FindMovies

  module ClassMethods

    # prompts user to enter a search term for their selected category
    # adds name of objects that meet the criteria to the PREVIOUSLY_ENTERED array
    # adds name of chosen object to previously entered array
    def new_get_movie_selection
      puts "Enter a film #{self.name.downcase}".colorize(:light_magenta)
      puts 'or type "back" to try a different criteria'.colorize(:light_magenta)
      input = get_input
      chosen = self.where("lower(name) = ?", input)[0]
      unless PREVIOUSLY_ENTERED[self.name].include?(chosen.name)
        PREVIOUSLY_ENTERED[self.name] << chosen.name
      end
      return if input.nil?

      # sets SELECTION[movie_list] to array of movies that correspond with the selected(actor, genre, etc) #if the array is empty
      #if not empty, store current movie list in SELECTION[:prev_movie_list], then narrow down selection
      if SELECTION[:movie_list].empty?
        SELECTION[:movie_list] = chosen.movies
        puts ""
        puts "So far, you have entered:\n".colorize(:light_magenta)
        output_entered
        recommendation
      else
        SELECTION[:prev_movie_list] = SELECTION[:movie_list]
        SELECTION[:movie_list] = self.narrow_by_self(input)

        #if new search parameter returns no results, set results to the previous results and output results
        if SELECTION[:movie_list].empty?
          SELECTION[:movie_list] = SELECTION[:prev_movie_list]
          too_many
        else
          puts ""
          puts "So far, you have entered".colorize(:red)
          output_entered
          recommendation
        end
      end
    end

    # Is called #when user enters a search tem that is not in the database
    def not_an_option
      puts "Sorry that #{self.name.downcase} is not an option.".colorize(:red)
      puts "Enter a different #{self.name.downcase} or type".colorize(:light_magenta)
      puts '"back" to change the search category'.colorize(:light_magenta)
      get_input
    end

    # Get and store input
    def get_input
      input = gets.strip.downcase
      90.times {puts ""}
      if input == "back"
        recommendation
        return
      end
      return self.not_an_option if self.where("lower(name) = ?", input)[0].nil?
      input
    end

    # Message for too many inputs
    def too_many
      puts "Sorry, that #{self.name.downcase} didn't return any matches".colorize(:red)
      puts "Please enter another #{self.name.downcase}".colorize(:light_magenta)
      puts 'or type "back" to try a different criteria'.colorize(:light_magenta)
      puts ''
      PREVIOUSLY_ENTERED[self.name].pop unless PREVIOUSLY_ENTERED[self.name].empty?
      movie_recommendations
    end

    #Narrows down previous selection of movies by new search criteria
    # Is called on all searches after the first search.
    # Iterates through movie_list (current results based on users inputted criteria)
    # Selects all movies that include the search criteria
    def narrow_by_self(input)
      SELECTION[:movie_list].select do |movie|
        classes = {
          'Genre' => movie.genres,
          'Actor' => movie.actors,
          'Director' => movie.directors
        }
        classes[self.name].include?(self.where("lower(name) = ?", input)[0])
      end
    end
  end
end
