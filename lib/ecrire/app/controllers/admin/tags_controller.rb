module Admin
  class TagsController < Admin::ApplicationController
    def index
      @tags = Tag.all
    end
  end
end
