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
        puts "#{key}: #{value.join(", ")}"
      end
    end

    # Message for too many inputs
    def too_many(prev_movie_list)
      puts "You have entered too many #{self.name.downcase}s."
      puts "Here are reccommendations for:"
      self.output_previously_entered
      puts prev_movie_list.map {|movie| movie.name}
    end

    #Helper for .narrow_movie_selection
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

    def narrow_movie_selection(movie_list:)
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
      puts "Here are your reccommendations for:"
      output_previously_entered
      puts movie_list.map {|movie| movie.name}
    end


  end
end
