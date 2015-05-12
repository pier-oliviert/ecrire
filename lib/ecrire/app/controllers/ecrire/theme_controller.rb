module Ecrire
  ##
  # The class any controller in a theme needs to inherit from
  #
  # +ThemeController+ provides boilerplate code so the blog handles a few cases
  # for you.
  #
  # Ecrire will try to redirect to the homepage when it meets selected exceptions
  # Currently, the following 3 exceptions are handled:
  # - ActiveRecord::RecordNotFound
  # - ActionController::RoutingError
  # - ActionView::ActionViewError
  #
  class ThemeController < ::ApplicationController

    unless Rails.env.development?
      rescue_from ActiveRecord::RecordNotFound, with: :redirect_home
      rescue_from ActionController::RoutingError, with: :redirect_home
      rescue_from ActionView::ActionViewError, with: :redirect_home
    end


    before_action :pagination, only: :index

    private

    def pagination
      params[:per] ||= 10
      params[:page] ||= 1
    end

    def redirect_home(exception)
      flash[:errors] = t('errors.request.not_found')
      redirect_to '/'
    end
  end
end
