class RecipeStep < ApplicationRecord
  belongs_to :recipe

  validates :step_number, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :instructions, presence: true
end
