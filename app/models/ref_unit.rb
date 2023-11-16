class RefUnit < ApplicationRecord
  before_validation :sanitize_fields

  # Validations
  validates :name, presence: true
  validates :abbreviation, presence: true
  validates :category, presence: true
  validates :unit_factor, presence: true
  validates :unit_reference, presence: true

  def sanitize_fields
    self.name = sanitize_strings(self.name)
    self.category = sanitize_strings(self.category)
    self.unit_reference = sanitize_strings(self.unit_reference)
  end

  def sanitize_strings(string)
    return string if string.blank?

    sanitized_string = string.downcase.capitalize
    sanitized_string.gsub(/\b([a-z])/) { $1.capitalize }
  end
end
