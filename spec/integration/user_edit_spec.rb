# frozen_string_literal: true

describe 'user edit test' do
  let(:user) do
    User.create(name: 'Test User',
                email: 'test@test.com',
                password: 'P@ssword123')
  end
  let(:edit_user_path) { "/users/#{user.id}/edit" }

  subject { put(user_path, params: params) }

  context 'unsuccessful edit' do
    let(:params) do
      { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } }
    end

    it do
      log_in_as(user)
      get edit_user_path
      expect(response).to render_template('users/edit')
      subject
      expect(response).to render_template('users/edit')
    end
  end

  context 'successful edit' do
    let(:params) do
      { user: { name: 'Foo Bar', email: 'foo@bar.com', password: '', password_confirmation: '' } }
    end

    it 'successful edit with friendly forwarding' do
      get edit_user_path
      log_in_as(user)
      expect(response).to redirect_to(edit_user_path)
      follow_redirect!
      # expect(response).to render_template('users/edit')
      subject
      expect(flash[:success]).to eq('Profile updated')
      expect(subject).to redirect_to user_path
      user.reload
      expect(user.name).to eq('Foo Bar')
      expect(user.email).to eq('foo@bar.com')
    end
  end
end
