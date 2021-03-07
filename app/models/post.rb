class Post < ActiveRecord::Base
  has_many :post_categories
  has_many :categories, through: :post_categories

  # Method needed to avoid creating new category if one already exists by the same name
  
  def categories_attributes=(category_attributes)
    category_attributes.values.each do |category_attribute|
      category = Category.find_or_create_by(category_attribute)
      self.post_categories.build(category: category)
    end
  end

end
