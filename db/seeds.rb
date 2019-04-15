require 'themoviedb-api'
require 'pry'

Tmdb::Api.key("9a306747f13ec661784ee120bacdd6fc")
binding.pry
Tmdb::Genre.movie_list.each do |genre|
  Genre.find_or_create_by(genre_id: genre.id, name: genre.name)
end

# Tmdb::Genre.movies(28).results

Tmdb::Genre.movie_list.map do |genre|
  Tmdb::Genre.movies(genre.id).results
end.flatten.each do |movie|
  Movie.find_or_create_by(movie_id: movie.id, name: movie.title, description: movie.overview)
end
