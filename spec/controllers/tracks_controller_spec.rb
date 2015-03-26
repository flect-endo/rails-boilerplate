require 'rails_helper'

RSpec.describe TracksController, type: :controller do

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #import" do
    it "returns http success" do
      get :import
      expect(response).to have_http_status(:success)
    end
  end

end
