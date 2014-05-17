module ConfigurationHelper
  def database_status
    if ActiveRecord::Base.connected?
      'Connected!'
    else
      'Not Connected yet'
    end
  end

  def user_layout_status
  end
end
