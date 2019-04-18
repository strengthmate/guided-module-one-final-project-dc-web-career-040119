require 'themoviedb-api'
require 'pry'

# Authenticate TMDB API
Tmdb::Api.key("9a306747f13ec661784ee120bacdd6fc")
# Populate genres table through TMDB API
Tmdb::Genre.movie_list.each do |genre|
  Genre.find_or_create_by(api_id: genre.id, name: genre.name.downcase)
end


# Get movies for each genre from TMBD
movie_list = Tmdb::Genre.movie_list.map do |genre|
  Tmdb::Genre.movies(genre.id).results
end.flatten

# Populate movies table with movies from TMDB
movie_list.each do |movie|
  Movie.find_or_create_by(
    api_id: movie.id,
    name: movie.title,
    description: movie.overview
  )
end

# Join movies and genres through id and api_id
movie_list.each do |movie|
  movie.genre_ids.each do |genre_id|
    MovieGenre.find_or_create_by(
      movie_api_id: movie.id,
      genre_api_id: genre_id,
      movie_id: Movie.find_by(api_id: movie.id).id,
      genre_id: Genre.find_by(api_id: genre_id).id
    )
  end
end

movie_list.each_with_index  do |movie,index|
  if index % 40 == 0
    sleep(11)
  end

  # Tmdb::Movie.cast(movie.id).each do |cast_member|
  #   Actor.find_or_create_by(
  #     api_id: cast_member.id,
  #     name: cast_member.name.downcase,
  #     )
  #   CastMember.find_or_create_by(
  #     movie_api_id: movie.id,
  #     movie_id: Movie.find_by(api_id: movie.id).id,
  #     actor_api_id: cast_member.id,
  #     actor_id: Actor.find_by(api_id: cast_member.id).id,
  #     character_name: cast_member.character
  #   )
  # end
  Tmdb::Movie.director(movie.id).each do |director|
    Director.find_or_create_by(
      api_id: director.id,
      name: director.name.downcase,
      )
    MovieDirector.find_or_create_by(
      movie_api_id: movie.id,
      movie_id: Movie.find_by(api_id: movie.id).id,
      director_api_id: director.id,
      director_id: Director.find_by(api_id: director.id).id,
    )
  end
end





