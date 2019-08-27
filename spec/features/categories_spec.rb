require 'rails_helper'

describe 'categories', type: 'feature' do

  before do
    @post = Post.create(title: "Feeling Groovy", content: "I'm feeling so groovy")
    @cool = @post.categories.build(name: "Cool")
    @post.save
  end

  describe 'show page' do

    it 'should display all of the related posts' do
      visit category_path(@cool)
      expect(page).to have_link(@post.title, href: post_path(@post))
    end

  end



end