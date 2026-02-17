class CreateSeriesProducers < ActiveRecord::Migration[8.0]
  def change
    create_table :series_producers do |t|
      t.references :series, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :series_producers, [ :series_id, :user_id ], unique: true
  end
end
