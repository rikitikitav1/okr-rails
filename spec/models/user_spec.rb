# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  let(:user) do
    User.new(name: 'Example User', email: 'user@example.com',
             password: 'Meow1!', password_confirmation: 'Meow1!')
  end

  context 'ordinnary checks' do
    it('is valid') { expect(user.valid?).to be true }

    context 'name' do
      it 'required' do
        user.name = ' '
        expect(user.valid?).to be false
      end

      it 'should be <= 50' do
        user.name = 'a' * 51
        expect(user.valid?).to be false
      end
    end

    context 'email' do
      it 'required' do
        user.email = ' '
        expect(user.valid?).to be false
      end

      it 'should be <= 255' do
        user.email = 'a' * 250 + '@meow.com'
        expect(user.valid?).to be false
      end

      it 'validation should accept valid addresses' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user.valid?).to be true
        end
      end

      it 'validation should reject invalid addresses' do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user.valid?).to be false
        end
      end

      it 'should be unique' do
        user.dup.save
        expect(user.valid?).to be false
      end

      it 'email addresses should be saved as lower-case' do
        mixed_case_email = 'Foo@ExAMPle.CoM'
        user.email = mixed_case_email
        user.save
        expect(user.reload.email).to eq(mixed_case_email.downcase)
      end

      context 'password' do
        it 'should have a minimum length' do
          user.password = user.password_confirmation = 'a' * 5
          expect(user.valid?).to be false
        end

        it 'password validation should reject invalid passwords' do
          invalid_passwords = %w[meow1! Meow11 MEOW!1 Meow!!]
          invalid_passwords.each do |invalid_pass|
            user.password = user.password_confirmation = invalid_pass
            expect(user.valid?).to be false
          end
        end

        it 'password validation should accept valid password' do
          valid_passwords = %w[Meow!1 Mw123@]
          valid_passwords .each do |valid_pass|
            user.password = user.password_confirmation = valid_pass
            expect(user.valid?).to be true
          end
        end
      end
    end
  end
end
