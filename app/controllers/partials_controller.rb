class PartialsController < ApplicationController
  def show
    render params[:id], layout: false
  end
end
