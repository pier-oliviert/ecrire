class UnauthenticatedController < ActionController::Base
  def failed
    respond_to do |format|
      format.html do
        redirect_to :root
      end
      format.js do
        render 'show' and return
      end
    end
  end
end
