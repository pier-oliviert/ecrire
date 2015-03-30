class StaticController < Ecrire::ThemeController
  def show
    render params[:view]
  end
end
