module Admin
  class TagsController < Admin::ApplicationController
    def create
      @tag = Admin::Tag.find_or_create_by!(tag_params)
    end

    protected

    def tag_params
      params.require(:tag).permit('name')
    end

  end
end
