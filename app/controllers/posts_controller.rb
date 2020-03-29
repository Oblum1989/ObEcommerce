class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :create]

  # GET /posts
  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end
    render json: @posts.includes(:user), status: :ok
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    if (@post.published? || (Current.user && @post.user_id == Current.user.id))
      render json: @post, status: :ok
    else 
      render json: {error: "Not Found"}, status: :not_found
    end
    
  end

  # POST /posts
  def create
    @post = Current.user.posts.new(create_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    @post = Current.user.posts.find(params[:id])
    if @post.update(update_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end

  private
    # Only allow a trusted parameter "white list" through.
    def create_params
      params.require(:post).permit(:title, :content, :published)
    end

    def update_params
      params.require(:post).permit(:title, :content, :published)
    end

    def authenticate_user!
      token_regex = /Bearer (\w+)/
      headers = request.headers
      if headers['HTTP_AUTHORIZATION'].present? && headers['HTTP_AUTHORIZATION'].match(token_regex)
        token = headers['HTTP_AUTHORIZATION'].match(token_regex)[1]
        if (Current.user = User.find_by(auth_token: token))
          return
        end
      end
      render json: {error: 'Unauthorized'}, status: :unauthorized
    end
    
end
