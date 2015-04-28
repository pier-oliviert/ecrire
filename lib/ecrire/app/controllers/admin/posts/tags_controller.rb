module Admin
  module Posts
    class TagsController < Admin::ApplicationController

      def index
        @post = Admin::Post.find(params[:post_id])
        @tags = Admin::Tag.all
      end

      def toggle
        @post = Admin::Post.find(params[:post_id])
        @tag = Admin::Tag.find(params[:tag_id])
        if @post.tags.include? @tag
          @post.tags = @post.tags.where.not(id: @tag.id)
        else
          @post.tags << @tag
        end

        @post.save!
      end

    end
  end
end
