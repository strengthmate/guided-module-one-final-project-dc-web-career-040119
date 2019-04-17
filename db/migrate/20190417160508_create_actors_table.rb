class CreateActorsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :actors do |t|
      t.integer :api_id
      t.string :name
    end
  end
end
