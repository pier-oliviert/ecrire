class SessionsController < ApplicationController
  before_action :authenticate!

  def create
    redirect_to :root
  end

  def destroy
    warden.logout
    redirect_to :back
  end
end
