require_dependency "admin/application_controller"

module Admin
  class PartialsController < ApplicationController

    def index
      @partials = Partial.all

      respond_to do |format|
        format.js
        format.html
      end
    end

  end
end
