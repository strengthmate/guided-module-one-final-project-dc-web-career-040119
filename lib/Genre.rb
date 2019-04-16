class Genre < ActiveRecord::Base
  has_many :movie_genres
  has_many :movies, through: :movie_genres


  def self.find_movies_by_genre_name(genre_selection)
      if genre_selection.downcase != "done"
        self.find_by(name: genre_selection).movies
      end
  end

  def self.narrow_movie_selection_by_genre(movie_list)
    puts "Enter another genre"
    genre_selection = gets.strip.downcase
    while genre_selection != "done"
      #To do: Check whether movie_list is empty.
      #If it is, return previous movie list
      movie_list = movie_list.select {|movie| movie.genres.include?(Genre.find_by(name: genre_selection))}
      puts "Enter another genre"
      genre_selection = gets.strip.downcase
    end
    puts movie_list.map {|movie| movie.name}
  end


end
