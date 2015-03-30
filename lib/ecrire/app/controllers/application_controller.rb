class ApplicationController < ::ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?

  helper_method :warden, :post_path

  def current_user
    warden.user
  end

  def signed_in?
    !warden.user.nil?
  end

  # This is the less ugly hack I could find. The reason why this is here
  # is because helpers are hard to debug due to their anonymous Module use.
  def post_path(post, options = {})
    options[:controller] = :posts
    options[:action] = :show
    options[:year] = post.published_at.year
    options[:month] = post.published_at.month

    options[:id] = (options.delete(:title) || post.titles.first).slug

    theme.url_for options
  end


  protected

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end
end
