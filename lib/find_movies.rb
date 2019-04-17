module FindMovies

  module ClassMethods

    # Store inputs for this session
    PREVIOUSLY_ENTERED = {
      'Genre' => []
    }.freeze

    # Get and store input
    def get_input
      input = gets.strip.downcase
      PREVIOUSLY_ENTERED[self.name] << input
      input
    end

    # Print all inputs for this session
    def output_previously_entered
      PREVIOUSLY_ENTERED[self.name].pop
      PREVIOUSLY_ENTERED.each do |key,value|
        puts "#{key}: #{value.join(", ")}".colorize(:yellow)
      end
    end

    # Message for too many inputs
    def too_many(prev_movie_list)
      puts "You have entered too many #{self.name.downcase}s.".colorize(:red)
      movie_recommendations(prev_movie_list)
    end

    #Helper for .get_movie_selection
    def narrow_by_self(movie_list:, input:)
      movie_list.select do |movie|
        classes = {
          'Genre' => movie.genres,
          # 'Actor' => movie.actors
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



    # Narrow down suggestions
    def get_movie_selection
      movie_list = find_movies_by_input
      puts "Enter another #{self.name.downcase}"
      input = get_input
      while input != "done"

        prev_movie_list = movie_list
        movie_list = self.narrow_by_self(movie_list: movie_list, input: input)

        if movie_list.empty?
          too_many(prev_movie_list)
          return
        end

        puts "Enter another #{self.name.downcase}"
        input = get_input
      end
      movie_recommendations(movie_list)
    end

    # Output movie recommendations
    def movie_recommendations(movie_list)
      puts "Here are your recommendations for:".colorize(:yellow)
      output_previously_entered
      puts movie_list.map {|movie| movie.name.colorize(:green)}
    end


  end
end
