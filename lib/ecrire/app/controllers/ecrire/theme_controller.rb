module Ecrire
  class ThemeController < ::ApplicationController

    unless Rails.env.development?
      rescue_from ActiveRecord::RecordNotFound, with: :redirect_home
      rescue_from ActionController::RoutingError, with: :redirect_home
      rescue_from ActionView::ActionViewError, with: :redirect_home
    end

    before_action :pagination, only: :index
    protect_from_forgery except: :index

    def index
      respond_to do |format|
        format.html
        format.rss
        format.json do
          headers['Access-Control-Allow-Origin'] = '*'
        end
      end
    end

    def show
    end

    protected

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
