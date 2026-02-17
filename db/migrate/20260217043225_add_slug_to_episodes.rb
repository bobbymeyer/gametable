class AddSlugToEpisodes < ActiveRecord::Migration[8.0]
  def change
    add_column :episodes, :slug, :string
    add_index :episodes, :slug, unique: true
  end
end
