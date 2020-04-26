class PostsController < ApplicationController
  include Secured
  
  before_action :authenticate_user!, only: [:update, :create]

  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end
    render json: @posts, status: :ok
  end

  def show
    @post = Post.find(params[:id])
    if (@post.published? || (Current.user && @post.user_id == Current.user.id))
      render json: @post, status: :ok
    else 
      render json: {error: "Not Found"}, status: :not_found
    end
    
  end

  def create
    @post = Current.user.posts.new(create_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    @post = Current.user.posts.find(params[:id])
    if @post.update(update_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end

  private
  
    def create_params
      params.require(:post).permit(:title, :content, :published)
    end

    def update_params
      params.require(:post).permit(:title, :content, :published)
    end

end
