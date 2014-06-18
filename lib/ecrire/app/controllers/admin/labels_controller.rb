module Admin
  class LabelsController < Admin::ApplicationController
    def create
      Admin::Label.create(label_param)
    end

    protected

    def label_param
      params.require(:admin_label).permit(:name)
    end

    def post
      @post ||= Post.find(params[:post_id])
    end

  end
end
