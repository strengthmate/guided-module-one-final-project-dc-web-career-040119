module FindMovies

  module ClassMethods

    PREVIOUSLY_ENTERED = {
      'Genre' => []
      }

    def get_input
      input = gets.strip.downcase
      PREVIOUSLY_ENTERED[self.name] << input
      input
    end

    def find_movies_by_input
      puts "Enter a film #{self.name.downcase}"
      input = get_input
      if input.downcase != "done"
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
          puts "You have entered too many #{self.name.downcase}s."
          puts "Here are reccommendations for:"    
          PREVIOUSLY_ENTERED.each do |key,value| value.pop
            puts "#{key}: #{value.join(", ")}"
          end
          puts prev_movie_list.map {|movie| movie.name}
        return
        end
        puts "Enter another #{self.name.downcase}"
        input = get_input
      end

      puts movie_list.map {|movie| movie.name}
    end

    def narrow_by_self(movie_list:, input:)
      movie_list.select do |movie|
      classes = {
      'Genre' => movie.genres,
      # 'Actor' => movie.actors
      }
        classes[self.name].include?(self.find_by(name: input))
      end
    end
  end
end
