class CreateRecipeSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_steps do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :step_number
      t.text :instructions

      t.timestamps
    end
  end
end
