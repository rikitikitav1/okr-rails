# frozen_string_literal: true

describe 'login test' do
  context 'come to login' do
    it { expect(get(login_path)).to render_template('sessions/new') }
  end

  context 'when invalid login/password' do
    subject { post(login_path, params: params) }
    before { get(login_path) }
    let(:params) { { session: { email: '', password: '' } } }

    it { expect(subject).to render_template('sessions/new') }

    it do
      subject
      expect(flash[:danger]).to eq('Invalid email/password combination')
    end
  end

  context 'when valid login/password and logout after' do
    let(:correct_pass) { 'P@ssword123' }
    let(:user) do
      User.create(name: 'Test User',
                  email: 'test@test.com',
                  password: correct_pass)
    end
    let(:params) { { session: { email: user.email, password: correct_pass } } }
    let(:user_path) { "/users/#{user.id}" }

    subject { post(login_path, params: params) }

    before { get(login_path) }

    it { expect(subject).to redirect_to user_path }

    it do
      subject
      follow_redirect!
      expect(response).to render_template('users/show')
      expect(response.body).to include("href=\"#{user_path}\"", 'href="/logout"')
      expect(response.body).not_to include('href="/login"')
      expect(logged_in?).to be true
      delete logout_path
      expect(session['user_id']).to be_nil
      follow_redirect!
      expect(response).to render_template('static_pages/home')
      expect(response.body).to include('href="/login"')
      expect(response.body).not_to include("href=\"#{user_path}\"", 'href="/logout"')
      # run logout at the other browser
      delete logout_path
      expect(subject).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('href="/login"')
      expect(response.body).not_to include("href=\"#{user_path}\"", 'href="/logout"')
    end
  end

  context 'cookies' do
    let(:user) do
      User.create(name: 'Test User',
                  email: 'test@test.com',
                  password: 'P@ssword123')
    end

    it do
      log_in_as(user, remember_me: 1)
      expect(cookies['remember_token']).not_to be_nil
    end

    it do
      log_in_as(user, remember_me: 0)
      expect(cookies['remember_token']).to be_nil
    end
  end
end
