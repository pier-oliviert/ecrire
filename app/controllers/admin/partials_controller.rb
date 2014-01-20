module Admin
  class PartialsController < Admin::ApplicationController

    def index
      @partials = Admin::Partial.page(params[:page]).per(params[:per_page])

      respond_to do |format|
        format.js
        format.html
      end
    end

    def new
      @partial = Admin::Partial.new
    end

    def edit
      @partial = Admin::Partial.find(params[:id].to_i)
    end

    def create
      @partial = Admin::Partial.create(partial_params)
    end

    def update
      @partial = Admin::Partial.find(params[:id].to_i).update(partial_params)
    end

    protected

    def partial_params
      params.require(:admin_partial).permit(:title, :content, :javascript, :stylesheet)
    end

  end
end
