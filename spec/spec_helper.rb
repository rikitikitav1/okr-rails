# frozen_string_literal: true

require 'rails_helper'
require 'rspec/rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Rails.application.routes.url_helpers
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def logged_in?
  !session[:user_id].nil?
end

def log_in_as(user, options = {})
  if integration_test?
    post login_path,
         params: { session: { email: user.email,
                              password: options.fetch(:password) { 'P@ssword123' },
                              remember_me: options.fetch(:remember_me) { '1' } } }
  else
    session[:user_id] = user.id
  end
end

def integration_test?
  defined?(post_via_redirect)
end

# for controllers

def login(user)
  user = User.where(login: user.to_s).first if user.is_a?(Symbol)
  request.session[:user_id] = user.id
end

def login_admin
  login(:admin)
end

def current_user
  User.find(request.session[:user])
end
