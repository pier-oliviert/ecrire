class ApplicationController < ::ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?

  helper_method :warden, :post_path, :url

  def current_user
    warden.user
  end

  def signed_in?
    !warden.user.nil?
  end

  def url(path, options = {})
    records = options.with_indifferent_access
    regex = /(:([a-z]+)\.([a-z]+))/i
    path.gsub! regex do |match|
      records[$2].send($3)
    end

    if options.delete(:full_path)
      options[:path] = path
      options[:host] ||= request.host
      options[:protocol] ||= request.protocol
      options[:port] ||= request.port
      ActionDispatch::Http::URL.full_url_for(options)
    else
      path
    end
  end


  protected

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end
end
