class RemoveStatsFromCharacters < ActiveRecord::Migration[8.0]
  def change
    remove_column :characters, :hp, :integer
    remove_column :characters, :ap, :integer
    remove_column :characters, :lvl, :integer
    remove_column :characters, :power, :integer
    remove_column :characters, :agility, :integer
    remove_column :characters, :mind, :integer
    remove_column :characters, :soul, :integer
    remove_column :characters, :costume, :text
  end
end
