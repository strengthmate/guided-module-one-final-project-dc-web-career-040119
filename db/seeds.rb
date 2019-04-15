require 'themoviedb-api'

Tmdb::Api.key("9a306747f13ec661784ee120bacdd6fc")

Tmdb::Genre.movie_list.each do |genre|
  Genre.find_or_create_by(genre_id: genre.id, name: genre.name)
end
