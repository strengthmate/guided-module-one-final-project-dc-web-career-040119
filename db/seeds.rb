require 'themoviedb-api'
require 'pry'

Tmdb::Api.key("9a306747f13ec661784ee120bacdd6fc")
Tmdb::Genre.movie_list.each do |genre|
  Genre.find_or_create_by(api_id: genre.id, name: genre.name)
end

# Tmdb::Genre.movies(28).results

movie_list = Tmdb::Genre.movie_list.map do |genre|
  Tmdb::Genre.movies(genre.id).results
end.flatten

movie_list.each do |movie|
  Movie.find_or_create_by(
    api_id: movie.id,
    name: movie.title,
    description: movie.overview,
  )
end

movie_list.each do |movie|
  movie.genre_ids.each do |genre|
    MovieGenre.find_or_create_by(movie_id: movie.id, genre_id: genre)
  end
end

MovieGenre.all.each do |movie_genre|
  movie_genre.movie_id = Movie.find_or_create_by(api_id: movie_genre.movie_api_id).id
  movie_genre.genre_id = Genre.find_or_create_by(api_id: movie_genre.genre_api_id).id
  movie_genre.save
end
