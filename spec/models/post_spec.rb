require 'rails_helper'

describe 'Post' do

  before do
    @post1 = Post.create(title: "New Test", content: "Create a test")
    
  end

  it 'has a title' do
    expect(@post1.title).to eq("New Test")
  end
end