# frozen_string_literal: true

describe SessionsHelper do
  let(:user) do
    User.create(name: 'Test User',
                email: 'test@test.com',
                password: 'P@ssword123')
  end

  before  { remember(user) }

  context 'current_user returns right user when session is nil' do
    it { expect(current_user).to eq user }
  end

  context 'current_user returns nil when remember digest is wrong' do
    before { user.update_attribute(:remember_digest, User.digest(User.new_token)) }
    it { expect(current_user).to be_nil }
  end
end
