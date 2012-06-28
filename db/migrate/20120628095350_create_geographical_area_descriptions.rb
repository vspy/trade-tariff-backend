class CreateGeographicalAreaDescriptions < ActiveRecord::Migration
  def change
    create_table :geographical_area_descriptions do |t|
      t.integer :geographical_area_description_period_sid
      t.string :language_id
      t.integer :geographical_area_sid
      t.string :geographical_area_id
      t.string :description

      t.timestamps
    end
  end
end