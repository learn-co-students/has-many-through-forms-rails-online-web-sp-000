require 'rails_helper'

RSpec.describe Category, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  before do
    @category_attributes = {}
    @category_attributes[:name] = "Best Category"
  end

  it 'has a name' do
    expect(Category.new(@category_attributes).name).to eq("Best Category")
  end

  it 'does not have a blank name' do
    @category_attributes[:name] = ""
    expect(Category.new(@category_attributes).valid?).to be(false)
  end
end
