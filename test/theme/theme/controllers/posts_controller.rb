class PostsController < Ecrire::ThemeController
  def index
    @posts = Post.published
  end

  def show
    @title ||= Title.find_by_slug!(params[:id])
    @post ||= @title.post
  end
end
