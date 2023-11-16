# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Volumen: Liters
RefUnit.create!(
  name: 'Liters',
  abbreviation: 'L',
  type: 'Volume',
  unit_factor: 1.0,
  unit_reference: 'Liters'
)

# Volumen: Milliliters
RefUnit.create!(
  name: 'Milliliters',
  abbreviation: 'mL',
  type: 'Volume',
  unit_factor: 0.001, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Volumen: Fluid Ounces
RefUnit.create!(
  name: 'Fluid Ounces',
  abbreviation: 'fl oz',
  type: 'Volume',
  unit_factor: 0.0295735, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Volumen: Cups
RefUnit.create!(
  name: 'Cups',
  abbreviation: 'cups',
  type: 'Volume',
  unit_factor: 0.236588, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Volumen: Pints
RefUnit.create!(
  name: 'Pints',
  abbreviation: 'pts',
  type: 'Volume',
  unit_factor: 0.473176, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Volumen: Quarts
RefUnit.create!(
  name: 'Quarts',
  abbreviation: 'qts',
  type: 'Volume',
  unit_factor: 0.946353, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Volumen: Gallons
RefUnit.create!(
  name: 'Gallons',
  abbreviation: 'gal',
  type: 'Volume',
  unit_factor: 3.78541, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Volume: Teaspoons
RefUnit.create!(
  name: 'Teaspoons',
  abbreviation: 'tsp',
  type: 'Volume',
  unit_factor: 0.00492892, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Volume: Tablespoons
RefUnit.create!(
  name: 'Tablespoons',
  abbreviation: 'Tbsp',
  type: 'Volume',
  unit_factor: 0.0147868, # Conversion factor to Liters
  unit_reference: 'Liters'
)

# Weight: Kilograms
RefUnit.create!(
  name: 'Kilograms',
  abbreviation: 'Kg',
  type: 'Weight',
  unit_factor: 1.0,
  unit_reference: 'Kilograms'
)

# Weight: Grams
RefUnit.create!(
  name: 'Grams',
  abbreviation: 'g',
  type: 'Weight',
  unit_factor: 0.001, # Conversion factor to Kilograms
  unit_reference: 'Kilograms'
)

# Weight: Ounces
RefUnit.create!(
  name: 'Ounces',
  abbreviation: 'oz',
  type: 'Weight',
  unit_factor: 0.0283495, # Conversion factor to Kilograms
  unit_reference: 'Kilograms'
)

# Weight: Pounds
RefUnit.create!(
  name: 'Pounds',
  abbreviation: 'lb',
  type: 'Weight',
  unit_factor: 0.453592, # Conversion factor to Kilograms
  unit_reference: 'Kilograms'
)

# Unit: Piece
RefUnit.create!(
  name: 'Piece',
  abbreviation: 'pc',
  type: 'Unit',
  unit_factor: 1.0,
  unit_reference: 'Piece'
)
