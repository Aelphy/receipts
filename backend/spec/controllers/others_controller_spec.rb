require 'rails_helper'

RSpec.describe OthersController, type: :controller do
  describe '#not_found' do
    before { get :not_found, path: :not_existing_path }

    it { expect(response).to have_http_status(:not_found) }
  end
end
