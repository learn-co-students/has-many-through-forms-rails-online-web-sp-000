class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    post = Post.create(post_params)
    redirect_to post
  end

  private

#nested params hash with data about the primary object
#association attributes
#key of :category_ids with a value of an array
#sql fires from creating our new post
#expect key of name inside for the category's name 
  def post_params
 params.require(:post).permit(:title, :content, category_ids:[], categories_attributes: [:name])
  end
end


#{"title"=>"New Post", "content"=>"Some great content!!", "category_ids"=>["2", "3", ""]}
