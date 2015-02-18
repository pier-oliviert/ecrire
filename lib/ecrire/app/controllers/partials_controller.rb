class PartialsController < ApplicationController
  def show
    @partial = Partial.find(params[:id].to_i)
    respond_to do |format|
      format.html { render layout: false }
    end
  end
end
