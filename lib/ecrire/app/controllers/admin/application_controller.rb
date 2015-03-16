require_relative '../application_controller'

module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate!
    before_action :pagination, only: [:index]

    helper_method :posts

    def posts
      @posts ||= Post.all
    end

    protected

    def pagination
      params[:per_page] ||= 10
      params[:page] ||= 1
    end

  end
end
