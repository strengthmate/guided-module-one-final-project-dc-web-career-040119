class CreateGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :actors do |t|
      t.integer :id
      t.string :name
    end
  end
end
