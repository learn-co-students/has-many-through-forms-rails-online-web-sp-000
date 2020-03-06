class Post < ActiveRecord::Base
  has_many :post_categories
  has_many :categories, through: :post_categories
  # accepts_nested_attributes_for :categories - doesn't prevent duplicates


  def categories_attributes=(category_attributes) #only creating a new category if it doesn't already exist with the current name
    category_attributes.values.each do |category_attribute|
      category = Category.find_or_create_by(category_attribute)
      #self.post_categories.build(category: category)
      self.categories << category #First, we call self.categories, which returns an array of Category objects, and then we call
      # the shovel (<<) method to add our newly found or created Category object to the array.
    end
  end

end
