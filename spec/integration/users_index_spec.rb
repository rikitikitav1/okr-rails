# frozen_string_literal: true

describe 'users index test' do
  fixtures :users
  let(:user) { users(:susel) }
  let(:admin) { users(:admin) }

  before do
    30.times do |n|
      User.create(name: "Test User#{n}",
                  email: "test#{n}@test.com",
                  password: "P@ssword#{n}")
    end
  end

  context 'when simple user' do
    it 'pagination is included' do
      log_in_as(user, password: 'P@ssword!123')
      get users_path
      is_expected.to render_template('users/index')
      expect(response.body).to include('aria-label="Pagination" class="pagination"')
      assert_select 'a', text: 'delete', count: 0
      User.paginate(page: 1).each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
      end
    end
  end

  context 'when admin' do
    let(:first_page_of_users) { User.paginate(page: 1) }

    before { log_in_as(admin, password: 'P@ssword!123') }

    it 'pagination is included' do
      get users_path
      is_expected.to render_template('users/index')
      expect(response.body).to include('aria-label="Pagination" class="pagination"')
      first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == admin
          assert_select 'a[href=?]', user_path(user), text: 'delete',
                                                      method: :delete
        end
      end
    end

    it { expect { delete user_path(user) }.to change(User, :count).by(-1) }
  end
end
