# frozen_string_literal: true

class User < ApplicationRecord
  EMAIL_REGEX = /\A[A-Za-z0-9_.+-]+@[A-Za-z0-9_.-]+\.[A-Za-z0-9_.-]+\Z/.freeze
  PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}\Z/.freeze

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: EMAIL_REGEX,
                              message: 'please enter email in correct format' },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 },
                       format: { with: PASSWORD_REGEX,
                                 message: 'password should contain each of upper/lower/digit/special' }
  has_secure_password
end
