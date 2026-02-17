class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.references :series, null: false, foreign_key: true
      t.string :name
      t.integer :hp
      t.integer :ap
      t.integer :xp
      t.integer :lvl
      t.integer :power
      t.integer :agility
      t.integer :mind
      t.integer :soul
      t.text :costume

      t.timestamps
    end
  end
end
