module FindMovies

  module ClassMethods



    def not_an_option
      puts "Sorry that #{self.name.downcase} is not an option.".colorize(:red)
      puts "Enter a different #{self.name.downcase} or enter".colorize(:red)
      puts '"back" to return to change the search category'.colorize(:red)
      get_input
    end

    # Get and store input
    def get_input
      input = gets.strip.downcase
      if input == "back"
        Movie.recommendation
        return
      end
      return self.not_an_option if self.find_by(name: input).nil?
      store_titleized_input(input)
    end

    def store_titleized_input(input)
      titleized_input = input.split.map do |word|
        if word.include? "-"
          word = word.split("-").map { |words| words.capitalize }.join("-")
        else
          word = word.capitalize
        end
      end.join(' ')

      PREVIOUSLY_ENTERED[self.name] << titleized_input
      input
    end

    # Print all inputs for this session
    def output_previously_entered
      PREVIOUSLY_ENTERED.each do |key,value|
        puts "#{key}: #{value.join(", ")}".colorize(:yellow)
      end
    end

    def output_entered
      puts "#" * 80
      puts ""
      puts "So far, you have entered".colorize(:red)
      PREVIOUSLY_ENTERED[self.name]
      PREVIOUSLY_ENTERED.each do |key,value|
        puts "#{key}: #{value.join(", ")}".colorize(:yellow)
      end
    end

    # Message for too many inputs
    def too_many
      puts "You have entered too many #{self.name.downcase}s.".colorize(:red)
      PREVIOUSLY_ENTERED[self.name].pop unless PREVIOUSLY_ENTERED[self.name].empty?
      movie_recommendations
    end

    #Helper for .get_movie_selection
    def narrow_by_self(input)
      SELECTION[:movie_list].select do |movie|
        classes = {
          'Genre' => movie.genres,
          'Actor' => movie.actors
        }
        classes[self.name].include?(self.find_by(name: input))
      end
    end

    # Get list of movies from search criteria
    def find_movies_by_input
      puts "Enter a film #{self.name.downcase}"
      input = get_input
      unless input.downcase == "done"
        self.find_by(name: input).movies
      end
    end



    def new_get_movie_selection
      puts "Enter a film #{self.name.downcase}"
      input = get_input
      binding.pry
      return if input.nil?
      if SELECTION[:movie_list].empty?
        SELECTION[:movie_list] = self.find_by(name: input).movies
        output_entered
        Movie.recommendation
      else
        SELECTION[:prev_movie_list] = SELECTION[:movie_list]
        SELECTION[:movie_list] = self.narrow_by_self(input)
        if SELECTION[:movie_list].empty?

          SELECTION[:movie_list] = SELECTION[:prev_movie_list]
          too_many
        else
          output_entered
          Movie.recommendation
        end
      end
    end

    # Output movie recommendations
    def movie_recommendations
      puts "Here are your recommendations for:".colorize(:yellow)
      output_previously_entered
      puts (SELECTION[:movie_list].map {|movie| movie.name.colorize(:green)})

      Movie.ending_prompt
    end


  end
end
