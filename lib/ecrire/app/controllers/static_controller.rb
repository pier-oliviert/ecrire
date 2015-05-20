##
# The Controller that renders static pages
#
# It looks for a a template matching the path provided.
#
class StaticController < Ecrire::ThemeController
  def show
    render "static/#{params[:view].to_s}"
  end
end
