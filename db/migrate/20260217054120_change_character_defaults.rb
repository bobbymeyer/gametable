class ChangeCharacterDefaults < ActiveRecord::Migration[8.0]
  def change
    change_column_default :characters, :hp, from: 0, to: 10
    change_column_default :characters, :lvl, from: 1, to: 0
  end
end
