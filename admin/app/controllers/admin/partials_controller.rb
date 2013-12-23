require_dependency "admin/application_controller"

module Admin
  class PartialsController < ApplicationController

    def index
      @partials = Partial.page(params[:page]).per(params[:per_page])

      respond_to do |format|
        format.js
        format.html
      end
    end

    def new
      @partial = Partial.new
    end

    def edit
      @partial = Partial.find(params[:id].to_i)
    end

    def create
      @partial = Partial.create(partial_params)
    end

    def update
      @partial = Partial.find(params[:id].to_i).update(partial_params)
    end

    protected

    def partial_params
      params.require(:partial).permit(:title, :content, :javascript, :stylesheet)
    end

  end
end
