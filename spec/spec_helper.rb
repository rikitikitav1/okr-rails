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
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def logged_in?
  !session[:user_id].nil?
end

def log_in_as(user, options = {})
  password = options[:password] || 'P@ssword123'
  remember_me = options[:remember_me] || '1'
  if integration_test?
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  else
    session[:user_id] = user.id
  end
end

def integration_test?
  defined?(post_via_redirect)
end
