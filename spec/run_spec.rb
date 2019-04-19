require_relative "../config/environment.rb"

describe "Actor" do
  it "has many movies" do
    expect(Actor.find(1).movies.empty?).to eq false
  end
end

describe "CastMember" do
  it "belongs to a movie and an actor" do
    expect(Movie.find(CastMember.find(1).movie_id)).not_to eq nil
    expect(Actor.find(CastMember.find(1).actor_id)).not_to eq nil
  end
end

describe "Director" do
  it "has many movie_directors" do
    expect(Director.find(1).movie_directors).not_to eq []
  end
end

describe "Genre" do
  it "has many movies" do
    expect(Genre.find(1).movie_genres).not_to eq []
  end
end

describe "Genre" do
  it "has many movies stored in an array" do
    expect(Genre.find(1).movies.length).to be > 0
  end
end
