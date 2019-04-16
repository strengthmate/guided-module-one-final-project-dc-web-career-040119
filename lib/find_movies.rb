module FindMovies

  module ClassMethods


    def find_movies_by_input
      puts "Enter a film #{self.name.downcase}"
      input = gets.strip.downcase
      if input.downcase != "done"
        self.find_by(name: input).movies
      end
    end

    def narrow_movie_selection(movie_list:)
      puts "Enter another #{self.name.downcase}"
      input = gets.strip.downcase
      while input != "done"
        # To do: Check whether movie_list is empty.
        # If it is, return previous movie list
        movie_list = self.narrow_by_self(movie_list: movie_list, input: input)
        puts "Enter another #{self.name.downcase}"
        input = gets.strip.downcase
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
