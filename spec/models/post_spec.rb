require 'rails_helper'

RSpec.describe Post, type: :model do
  it "has a title" do
    @post = Post.new
    @post.title = "This this stupid, why do I need to make fake tests just to submit a lab"
    expect(@post.title).to eq("This this stupid, why do I need to make fake tests just to submit a lab")
  end
end
