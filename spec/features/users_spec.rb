require 'rails_helper'

describe 'users', type: 'feature' do

  before do
    @post = Post.create(title: "Feeling Groovy", content: "I'm feeling so groovy")
    @user = User.create(username: 'CoolGuy5')
    @comment = @post.comments.build(content: "Great Post!", user: @user)
    @post.save
  end

  describe 'show page' do

    it 'should link to all of the posts the user commented on' do
      visit user_path(@user)
      expect(page).to have_link(@post.title, href: post_path(@post))
    end

  end



end