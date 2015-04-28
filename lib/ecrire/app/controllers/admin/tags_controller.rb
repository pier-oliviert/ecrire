module Admin
  class TagsController < Admin::ApplicationController
    def index
      @tags = Admin::Tag.all
      @tag = Admin::Tag.new
    end

    def create
      @tag = Admin::Tag.new(tag_params)
      if @tag.save
        redirect_to '/admin/tags' and return
      end

      @tags = Admin::Tag.all
      render 'index'
    end

    def destroy
      @tag = Admin::Tag.find(params[:id])
      @tags = Admin::Tag.all.where.not(id: @tag.id)

      if @tag.posts.any? && !params.has_key?(:confirmed)
        render 'destroy' and return
      end

      if params.has_key?(:transfer_tag_id)
        Post.transaction do
          transfer_tag = Admin::Tag.find(params[:transfer_tag_id])
          posts = @tag.posts
          posts.each do |post|
            post.tags << transfer_tag
            post.save
          end
        end
      end

      @tag.delete
      redirect_to '/admin/tags' and return
    end

    protected

    def tag_params
      params.require('tag').permit(:name, :confirmed)
    end
  end
end
