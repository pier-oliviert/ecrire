module Admin
  module Posts
    class TagsController < Admin::ApplicationController
      before_action :post

      def index
        @tags = Admin::Tag.all
        if params.has_key?(:q) && !params[:q].blank?
          @tags = @tags.search_by_name(params[:q])
        end
      end

      def create
        @tag = Tag.search_by_name(tag_params[:name]).first
        if @tag.nil?
          @tag = Tag.create(tag_params)
        end

        if @post.tags.include? @tag
          @post.tags = @post.tags.where.not(id: @tag.id)
        else
          @post.tags << @tag
        end

        @post.save!

      end

      def toggle
        @tag = Admin::Tag.find(params[:tag_id])
        if @post.tags.include? @tag
          @post.tags = @post.tags.where.not(id: @tag.id)
        else
          @post.tags << @tag
        end

        @post.save!
      end

      protected

      def post
        @post ||= Admin::Post.find(params[:post_id])
      end

      def tag_params
        params.require(:tag).permit(:name)
      end

    end
  end
end
