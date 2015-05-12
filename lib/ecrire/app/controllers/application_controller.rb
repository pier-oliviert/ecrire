##
# Base controller for every controller in Ecrire (Theme & Admin)
# Ecrire::ThemeController inherits from this class so there are no reason why
# you should inherit from this class.
#
# The controller handles user authentication, and CSRF protection.
#
# It also provides a +url+ method to build complex URL using a
# very light syntax.
#
class ApplicationController < ::ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?
  helper_method :warden, :post_path, :url

  ##
  # Return current signed +user+ or nil, if the user is not
  # signed in
  def current_user
    warden.user
  end

  ##
  # Returns +true+ if the user is signed in
  def signed_in?
    !warden.user.nil?
  end


  ##
  # Returns a URL based on the path and options provided.
  # It does not try to validate the URL, it only generates it and assume
  # it's a valid URL.
  #
  # +path+: The relative path of the URL you want to build.
  #
  # +options+: Hash containing options for rendering the url.
  #
  #
  # The +path+ and +options+ are linked together via a mapping construct
  # that you can use to map records to part of the URL.
  #
  # To map records to the +path+, you need to specify the record & the method you want to use inside the path.
  #
  #   url('/admin/posts/:posts.id', post: @post) 
  #   -> '/admin/posts/32'
  #
  # The method looks for every occurence of ":[key].[method]" and will look in +options+ for that key and call the given method on that key.
  #
  # This means the object can be anything as long as it handles the method.
  #
  # Here are a other examples:
  #
  #   url('/users/:user.id/tags/:tag.id/', user: @user, tag: @tag)
  #   -> '/users/12/tags/12'
  #
  #   url('/users')
  #   -> '/users'
  #
  # The +options+ also looks for the +absolute_path+ key. If it's set to +true+, the
  # method will return an absolute path.
  #
  #   url('/users/:user.id/tags/:tag.id/', user: @user, tag: @tag, absolute_path: true)
  #   -> 'http://localhost:3000/users/12/tags/12'
  #
  #   url('/users', absolute_path: true)
  #   -> 'http://localhost:3000/users'
  #
  
  def url(path, options = {})
    records = options.with_indifferent_access
    regex = /(:([a-z]+)\.([a-z]+))/i
    path = path.gsub regex do |match|
      records[$2].send($3)
    end

    if options.delete(:absolute_path)
      options[:path]        = path
      options[:host]      ||= request.host
      options[:protocol]  ||= request.protocol
      options[:port]      ||= request.port
      ActionDispatch::Http::URL.full_url_for(options)
    else
      path
    end
  end

  private

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end

end
