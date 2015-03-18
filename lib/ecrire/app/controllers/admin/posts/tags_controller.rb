module Admin
  module Posts
    class TagsController < Admin::ApplicationController
      def index
        @post = Admin::Post.find(params[:post_id])
        @tags = Admin::Tag.where.not(id: @post.tags.map(&:id))
      end

      def update
        @post = Admin::Post.find(params[:post_id])
        @tag = Admin::Tag.find(params[:id])
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
