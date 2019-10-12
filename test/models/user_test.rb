# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'Meow1!', password_confirmation: 'Meow1!')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'name should <= 50' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should be email' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'email should be <= 255' do
    @user.email = 'a' * 250 + '@meow.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'password validation should reject invalid passwords' do
    invalid_passwords = %w[meow1! Meow11 MEOW!1 Meow!!]
    invalid_passwords.each do |invalid_pass|
      @user.password = @user.password_confirmation = invalid_pass
      assert_not @user.valid?, "#{invalid_pass.inspect} should be invalid"
    end
  end

  test 'password validation should accept valid password' do
    valid_passwords = %w[Meow!1 Mw123@]
    valid_passwords .each do |valid_pass|
      @user.password = @user.password_confirmation = valid_pass
      assert @user.valid?, "#{valid_pass.inspect} should be valid"
    end
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
end
