class CreateRefDifficulties < ActiveRecord::Migration[7.1]
  def change
    create_table :ref_difficulties do |t|
      t.string :name

      t.timestamps
    end
  end
end
