require "rails_helper"

RSpec.describe "Auth::Sessions API", type: :request do
  let(:user) { create(:user, role: :member) }

  describe "POST /api/auth/sign_in" do
    it "returns 200 with valid credentials" do
      post "/api/auth/sign_in",
           params: { api_user: { email: user.email, password: "Password123!" } }
      expect(response).to have_http_status(:ok)
      expect(json["data"]["email"]).to eq(user.email)
      expect(json["message"]).to be_present
    end

    it "returns 401 with invalid password" do
      post "/api/auth/sign_in",
           params: { api_user: { email: user.email, password: "wrong" } }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with unknown email" do
      post "/api/auth/sign_in",
           params: { api_user: { email: "nobody@example.com", password: "Password123!" } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/auth/sign_out" do
    it "returns 200 when signed in" do
      sign_in user
      delete "/api/auth/sign_out"
      expect(response).to have_http_status(:ok)
      expect(json["message"]).to be_present
    end
  end

  def json
    JSON.parse(response.body)
  end
end
