class BackfillFriendlyIdSlugs < ActiveRecord::Migration[8.0]
  def up
    Series.find_each(&:save)
    Episode.find_each(&:save)
  end

  def down
  end
end
