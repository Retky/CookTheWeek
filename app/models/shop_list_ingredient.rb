class ShopListIngredient < RelatedIngredient
  belongs_to :shop_list

  def sum_quantity(new_value)
    self.quantity += new_value
    save
  end
end
