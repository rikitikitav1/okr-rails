# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token
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

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
