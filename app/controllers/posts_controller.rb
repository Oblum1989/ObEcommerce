class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all
    render json: @posts.to_json, status: :ok
  end

  # GET /posts/1
  def show
    render json: @post.to_json, status: :ok
  end

  # POST /posts
  def create
    @post = Post.new(create_params)

    if @post.save
      render json: @post.to_json, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(update_params)
      render json: @post.to_json
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def create_params
      params.require(:post).permit(:title, :content, :published, :user_id)
    end

    def update_params
      params.require(:post).permit(:title, :content, :published)
    end
end
