class CreateRefUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :ref_units do |t|
      t.string :name
      t.string :abbreviation
      t.string :category
      t.float :unit_factor
      t.string :unit_reference

      t.timestamps
    end
  end
end
