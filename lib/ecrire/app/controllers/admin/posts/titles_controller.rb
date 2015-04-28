module Admin
  module Posts
    class TitlesController < Admin::ApplicationController

      def index
        @post = Admin::Post.find(params[:post_id])
        if @post.published?
          @title = @post.titles.new
        else
          @title = @post.titles.first
        end
      end

      def create
        @post = Admin::Post.find(params[:post_id])
        @title = @post.titles.new(title_params)
        if @title.save
          redirect_to admin_post_titles_path(@title.post) and return
        end

        render 'index'
      end

      def update
        @title = Admin::Title.find(params[:id])
        if @title.update(title_params)
          redirect_to admin_post_titles_path(@title.post) and return
        end

        render 'index'
      end

      protected

      def title_params
        params.require(:title).permit(:name)
      end
    end
  end
end
