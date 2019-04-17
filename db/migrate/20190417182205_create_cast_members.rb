class CreateCastMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :cast_members do |t|
      t.integer :movie_api_id
      t.integer :actor_api_id
      t.integer :movie_id
      t.integer :actor_id
      t.string :character_name
    end
  end
end
