class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.integer :id
      t.string :name
      t.text :description
    end
  end
end

