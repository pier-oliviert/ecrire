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
    year = post.published_at.year
    month = post.published_at.month

    title = options.delete(:title) || post.titles.first

    url_for "/#{[year, month, title.slug].join('/')}"
  end


  protected

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end
end
