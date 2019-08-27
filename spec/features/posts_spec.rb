require 'rails_helper'

describe 'Posts', type: 'feature' do

  describe 'new' do

    before :each do
      @cool = Category.create(name: 'Cool')
      visit 'posts/new'
      fill_in('post_title', :with => 'Feeling Awesome')
      fill_in('post_content', :with => 'This is going to be an awesome post!')
    end

    it 'can create a post without a new category' do
      click_button('Create Post')
      @category = Post.last.categories.first.name
      expect(@category).to be_empty
      expect(page).to have_content('Feeling Awesome')
    end

    it 'can create a post with a previously created category' do
      check('Cool')
      click_button('Create Post')
      @category = Post.last.categories.first.name
      expect(@category).to eq('Cool')
    end

    it 'can create a post with a brand new category' do
      fill_in('post_categories_attributes_0_name', :with => 'Funny')
      click_button('Create Post')
      @category = Post.last.categories.first.name
      expect(@category).to eq('Funny')
    end

    it 'can create a post with a brand new category and an existing category' do
      check('Cool')
      fill_in('post_categories_attributes_0_name', :with => 'Funny')
      click_button('Create Post')
      @category1 = Post.last.categories.first.name
      @category2 = Post.last.categories.last.name
      expect(@category1).to eq('Cool')
      expect(@category2).to eq('Funny')
    end
  end

  describe 'show' do
    before do
      @category = Category.create(name: "Cool")
      @post = Post.create(title: "So Awesome", content: "Man am I a great blogger OR WHAT!")
      @post.categories << @category
      @user = User.create(username: 'RealBigFish')
      @comment1 = Comment.create(content: "This was great!", user: @user, post: @post)
    end

    it 'should display the title' do
      visit post_path(@post)
      expect(page).to have_content(@post.title)
    end

    it 'should display the content' do
      visit post_path(@post)
      expect(page).to have_content(@post.content)
    end

    it 'should display the categories' do
      visit post_path(@post)
      expect(page).to have_content(@post.categories.first.name)
    end

    it 'should display all of the comments for that post' do
      visit post_path(@post)
      expect(page).to have_content(@comment1.content)
    end

    it 'should display a list of unique users who have commented on the post' do |variable|
      @comment2 = Comment.create(content: "And another thing, how come there aren't any vegetabls at the movie theater...", user: @user, post: @post)
      visit post_path(@post)
      expect(page).to have_link(@user.username, href: user_path(@user), count: 1)
    end
  end
end