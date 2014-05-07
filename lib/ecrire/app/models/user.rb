require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  attr_accessor :password

  def password
    return if self.encrypted_password.blank?
    @password ||= Password.new(self.encrypted_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end
end
