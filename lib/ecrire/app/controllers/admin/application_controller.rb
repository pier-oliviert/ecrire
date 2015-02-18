require_relative '../application_controller'

module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate!
    before_action :pagination, only: [:index]

    protected

    def pagination
      params[:per_page] ||= 10
      params[:page] ||= 1
    end

  end
end
