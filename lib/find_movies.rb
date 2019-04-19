module FindMovies

  module ClassMethods

    def new_get_movie_selection
      puts "Enter a film #{self.name.downcase}".colorize(:light_magenta)
      puts 'or type "back" to try a different criteria'.colorize(:light_magenta)
      input = get_input
      chosen = self.where("lower(name) = ?", input)[0]
      unless PREVIOUSLY_ENTERED[self.name].include?(chosen.name)
        PREVIOUSLY_ENTERED[self.name] << chosen.name
      end
      return if input.nil?
      if SELECTION[:movie_list].empty?
        SELECTION[:movie_list] = chosen.movies
        puts ""
        puts "So far, you have entered:\n".colorize(:light_magenta)
        output_entered
        recommendation
      else
        SELECTION[:prev_movie_list] = SELECTION[:movie_list]
        SELECTION[:movie_list] = self.narrow_by_self(input)
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

    #Helper for .get_movie_selection
    def narrow_by_self(input)
      # binding.pry
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
