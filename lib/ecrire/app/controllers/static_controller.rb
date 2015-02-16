class StaticController < ApplicationController
  def show
    render params[:view]
  end
end
