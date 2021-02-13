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

  def post_params
    params.require(:post).permit(:title, :content, category_ids:[], categories_attributes: [:name])
    #category_ids collects the ids of existent categories to associate with the post, categories_attributes[:name] collects any new categories you want to add.
    #the html/erb code is
    # <%= f.collection_check_boxes :category_ids, Category.all, :id, :name %>
    # <%= f.fields_for :categories, post.categories.build do |categories_fields| %>
    #   <%= categories_fields.text_field :name %>
    # <% end %>
  end
end
