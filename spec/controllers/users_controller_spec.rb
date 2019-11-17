# frozen_string_literal: true

describe UsersController, type: :controller do
  fixtures :users

  let(:admin) { users(:admin) }
  let(:user1) { users(:susel) }
  let(:user2) { users(:tiger) }

  context 'new' do
    it do
      get 'new'
      expect(response).to render_template(:new)
    end
  end

  context 'when not logged in' do
    it 'should redirect edit' do
      get :edit, params: { id: user1.id }
      expect(flash[:danger]).to eq('Please log in.')
      is_expected.to redirect_to login_path
    end

    it 'should redirect update' do
      put :update, params: { id: user1.id, user: { name: user1.name, email: user1.email } }
      expect(flash[:danger]).to eq('Please log in.')
      is_expected.to redirect_to login_path
    end

    it 'should redirect index' do
      get :index
      is_expected.to redirect_to login_path
    end
  end

  context 'when logged in' do
    let(:edit_user_path) { "/users/#{user1.id}/edit" }
    it 'should render edit' do
      login(user1)
      get :edit, params: { id: user1.id }
      expect(response).to render_template('users/edit')
    end

    it 'should flash success' do
      login(user1)
      put :update, params: { id: user1.id, user: { name: user1.name, email: user1.email } }
      expect(flash[:success]).to eq('Profile updated')
    end
  end

  context 'when logged ad wrong user' do
    it 'should redirect edit' do
      login(user2)
      get :edit, params: { id: user1.id }
      is_expected.to redirect_to root_path
    end

    it 'should redirect update' do
      login(user2)
      put :update, params: { id: user1.id, user: { name: user1.name, email: user1.email } }
      is_expected.to redirect_to root_path
    end
  end

  context '#delete' do
    subject { delete :destroy, params: { id: user1 } }
    let(:user_count) { User.count }
    context 'when not logged in' do
      it { expect { subject }.not_to change(User, :count) }
      it { is_expected.to redirect_to login_path }
    end

    context 'when logged as a non-admin' do
      before { login(user2) }
      it { expect { subject }.not_to change(User, :count) }
      it { is_expected.to redirect_to root_path }
    end

    context 'when logged as an admin' do
      before { login(admin) }
      it { expect { subject }.to change(User, :count).by(-1) }
      it { is_expected.to redirect_to users_path }
    end
  end

  context 'should not addlow edit admin attribute via Web' do
    before { login(user2) }

    it { expect(user2.admin?).to be false }

    it { expect { put(:update, params: {}) } }

    it do
      patch :update, params: { id: user2, user: { password: 'Pa@ss123',
                                                  password_confirmation: 'Pa@ss123',
                                                  admin: true } }
      expect(user2.reload.admin?).to be false
    end
  end
end
