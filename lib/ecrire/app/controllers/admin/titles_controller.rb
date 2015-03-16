module Admin
  class TitlesController < Admin::ApplicationController
    helper_method :post

    def index
      if post.draft?
        render 'edit' and return
      end
    end

    def create
      @title = Admin::Title.new(title_params) do |title|
        title.post = post
      end

      unless @title.save
        render 'errors'
      end
    end

    def update
      @title = Admin::Title.find(params[:id])
      unless @title.update(title_params)
        render 'errors'
      end
    end

    protected

    def title_params
      params.require(:title).permit(:name)
    end

    def post
      @post ||= Post.find(params[:post_id])
    end

  end
end
