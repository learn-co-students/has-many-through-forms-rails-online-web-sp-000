require 'rails_helper'

RSpec.describe PostCategory, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  before do
    @post = Post.create(title: "Awesome Title", content: "Best Post Content")
    @post.categories.build(name: "Category 1")
    @post.categories.build(name: "Category 2")
  end

  it 'has a category' do
    expect(@post.categories.first).to be_kind_of(Category)
  end

  it 'has multiple categories' do
    expect(@post.categories.size).to eq(2)
  end
end
