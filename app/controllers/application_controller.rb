class ApplicationController < ActionController::Base
  prepend_view_path ['themes', Rails.configuration.theme].join('/')

  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?
  
  helper_method :menu

  def menu
    @menu ||= Admin::MenuHelper::Menu.new request do |menu|
      menu.add :blog do |item|
        item.path = root_path
        item.label = "&#128214;".html_safe
        item.id = 'blogPublicHome'
        item.highlight_when do |request|
          !request.path.start_with?('/admin')
        end
      end

      menu.add :posts do |item|
        item.path = admin_posts_path
        item.label = I18n.t('admin.navigation.posts')
        item.highlight_when do |request|
          request.env['action_controller.instance'].kind_of?(Admin::PostsController)
        end
      end

      menu.add :partials do |item|
        item.path = admin_partials_path
        item.label = I18n.t('admin.navigation.partials')
        item.highlight_when do |request|
          request.env['action_controller.instance'].kind_of?(Admin::PartialsController)
        end
      end
    end
  end

  def current_user
    warden.user
  end

  def signed_in?
    !warden.user.nil?
  end

  protected

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end
end
