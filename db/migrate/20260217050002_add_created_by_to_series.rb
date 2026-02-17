class AddCreatedByToSeries < ActiveRecord::Migration[8.0]
  def change
    add_reference :series, :created_by, null: true, foreign_key: { to_table: :users }
  end
end
