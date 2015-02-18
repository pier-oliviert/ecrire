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
      respond_to do |format|
        format.html do
          redirect_to edit_admin_partial_path(@partial)
        end
      end
    end

    def update
      @partial = Admin::Partial.find(params[:id].to_i)
      @partial.update(partial_params)
      redirect_to edit_admin_partial_path(@partial) and return
    end

    protected

    def partial_params
      params.require(:admin_partial).permit(:title, :content, :javascript, :stylesheet)
    end

  end
end
