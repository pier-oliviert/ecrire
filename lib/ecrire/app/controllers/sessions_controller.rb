class SessionsController < ApplicationController
  before_action :authenticate!, except: [:failed, :new]

  def create
    redirect_to :root
  end

  def destroy
    warden.logout
    redirect_to :back
  end

  def failed
    respond_to do |format|
      format.html do
        render 'new'
      end
      format.js do
        render 'show' and return
      end
    end
  end
end
