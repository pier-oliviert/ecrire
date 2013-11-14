module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate!

  end
end
