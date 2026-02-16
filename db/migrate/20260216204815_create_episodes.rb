class CreateEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_table :episodes do |t|
      t.references :series, null: false, foreign_key: true
      t.string :title
      t.date :session_date
      t.text :notes

      t.timestamps
    end
  end
end
