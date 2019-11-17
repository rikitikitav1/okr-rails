# frozen_string_literal: true

describe UsersController, type: :controller do
  context 'new' do
    it do
      get 'new'
      expect(response).to render_template(:new)
    end
  end
end
