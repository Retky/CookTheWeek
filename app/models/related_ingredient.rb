class RelatedIngredient < ApplicationRecord
  belongs_to :ingredient

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :unit, presence: true

  def convert_unit(new_unit)
    return if unit == new_unit

    if quantity.zero?
      self.unit = new_unit
    else
      current_unit = RefUnit.find_by(name: unit)
      next_unit = RefUnit.find_by(name: new_unit)

      self.unit = new_unit
      self.quantity = (quantity * current_unit.unit_factor) / next_unit.unit_factor
    end
  end
end
