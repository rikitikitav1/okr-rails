# frozen_string_literal: true

describe 'signup test' do
  let(:users_path) { '/users' }
  let(:signup_path) { '/signup' }
  let(:params) do
    { user: { name: '',
              email: 'user@invalid',
              password: 'foo',
              password_confirmation: 'bar' } }
  end

  before { get signup_path }

  subject { post(users_path, params: params) }

  context 'when invalid signup information' do
    it { expect { subject }.to_not change(User, :count) }
    it { expect(subject).to render_template('shared/_error_messages', 'users/new') }

    it do
      subject
      expect(response.body).to include('Name can&#39;t be blank')
      expect(response.body).to include('Email please enter email in correct format')
      expect(response.body).to include('Password is too short (minimum is 6 characters)')
      expect(response.body).to include('Password password should contain each of upper/lower/digit')
      expect(response.body).to include('Password confirmation doesn&#39;t match Password')
    end
  end

  context 'when valid signup information' do
    let(:params) do
      { user: { name: 'Example Use',
                email: 'user@valid.params',
                password: 'P@ssword!123',
                password_confirmation: 'P@ssword!123' } }
    end

    it { expect { subject }.to change(User, :count) }

    it { expect(subject).to redirect_to('/users/1') }

    it do
      subject
      expect(flash[:success]).to eq('Welcome to the Sample App!')
    end
  end
end
