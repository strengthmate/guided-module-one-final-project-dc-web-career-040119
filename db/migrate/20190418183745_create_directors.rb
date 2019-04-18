class CreateDirectors < ActiveRecord::Migration[5.2]
  def change
    create_table :directors do |t|
      t.integer :api_id
      t.string :name
    end
  end
end
