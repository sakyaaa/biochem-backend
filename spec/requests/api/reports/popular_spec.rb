require "rails_helper"

RSpec.describe "Reports::Popular API", type: :request do
  let!(:article) { create(:article, status: :published) }

  before do
    create(:view_log, article: article, created_at: 1.week.ago)
  end

  describe "GET /api/reports/popular" do
    it "returns 200" do
      get "/api/reports/popular"
      expect(response).to have_http_status(:ok)
    end

    it "includes meta with from and to" do
      get "/api/reports/popular"
      meta = json["meta"]
      expect(meta).to include("from", "to")
    end

    it "respects from/to params" do
      get "/api/reports/popular",
          params: { from: 14.days.ago.to_date.to_s, to: Date.today.to_s }
      expect(response).to have_http_status(:ok)
      expect(json_data).to be_an(Array)
    end

    it "returns 400 for invalid date format" do
      get "/api/reports/popular", params: { from: "invalid-date" }
      expect(response).to have_http_status(:bad_request)
    end
  end

  def json
    JSON.parse(response.body)
  end

  def json_data
    json["data"]
  end
end
