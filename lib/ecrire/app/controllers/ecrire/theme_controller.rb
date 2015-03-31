module Ecrire
  class ThemeController < ::ApplicationController

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
  end
end
