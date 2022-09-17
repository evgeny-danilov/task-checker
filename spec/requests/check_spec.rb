require 'rails_helper'

RSpec.describe "Checks", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/check/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /check" do
    it "returns http success" do
      get "/check/check"
      expect(response).to have_http_status(:success)
    end
  end

end
