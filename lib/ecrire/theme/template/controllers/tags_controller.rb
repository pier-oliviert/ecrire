class TagsController < Ecrire::ThemeController
  def show
    @tags = Tag.all
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.includes(:titles).page(params[:page]).per(params[:per])
  end
end

