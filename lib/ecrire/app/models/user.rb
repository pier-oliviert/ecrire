require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessor :password_confirmation

  validates_presence_of :email

  validate do |record|
    record.errors.add(:password, :blank) unless record.encrypted_password.present?
  end

  validates_confirmation_of :password, if: ->{ password.present? }

  def password
    return if self.encrypted_password.blank?
    @password ||= Password.new(self.encrypted_password)
  end

  def password=(new_password)
    if new_password.nil?
      self.encrypted_password = nil
    elsif new_password.present?
      @password = Password.create(new_password)
      self.encrypted_password = @password
    end
  end


end
