class RenameEpisodesTitleToName < ActiveRecord::Migration[8.0]
  def change
    rename_column :episodes, :title, :name
  end
end
