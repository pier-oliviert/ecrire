module Admin
  class PropertiesController < Admin::ApplicationController
    INSTANCES = {
      label: Property::Label
    }.with_indifferent_access

    helper_method :post

    def create
      instance = instance_for_property(params[:property])
      @property = instance.create(params[:value])
      render "admin/properties/#{instance.name}/create"
    end

    def destroy
      instance = instance_for_property(params[:property])
      @property = instance.destroy(params[:value])
      render "admin/properties/#{instance.name}/destroy"
    end

    protected

    def post
      @post ||= Admin::Post.find(params[:post_id])
    end

    def instance_for_property(name)
      instance = INSTANCES[name].new
      instance.post = post
      instance
    end

  end
end
