class Post < ActiveRecord::Base
  has_many :post_categories
  has_many :categories, through: :post_categories
  #accepts_nested_attributes_for :categories
#bi directional has many through


#customize the way our category is created by making this method
#creating a new category if it doesn't already exist with the current name
#call self.categories returns an array of category objects
# then shovel << method to add our newly found or created Category object to the array
  def categories_attributes=(category_attributes)
    category_attributes.values.each do |category_attribute|
      category = Category.find_or_create_by(category_attribute)
      self.categories << category
    end
  end
end


#customizing active record a little bit 
