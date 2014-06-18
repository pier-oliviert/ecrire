module Admin
  class PropertiesController < Admin::ApplicationController
    def create
      @property = post.properties.new
      @property.data = label
      @property.save!
    end

    def destroy
      @property = Admin::Property.find(params[:id])
      @property.destroy
    end

    protected

    def post
      @post ||= Admin::Post.find(params[:post_id])
    end

    def label
      @label ||= begin
                   if params.has_key?(:label_id)
                     Admin::Label.find(params[:label_id])
                   elsif params.has_key?(:admin_label)
                     Admin::Label.create(label_param)
                   end
                 end
    end

    def label_param
      params.require(:admin_label).permit(:name)
    end
  end
end
