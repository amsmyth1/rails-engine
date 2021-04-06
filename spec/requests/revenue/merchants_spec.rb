require 'rails_helper'

RSpec.describe "Merchant Revenue API" do
  it "returns the total revenue for a single merchant" do
    merchant = create(:merchant)
    get "/api/v1/revenue/merchants/#{merchant.id}"

    expect(response).to be_successful

    revenue = JSON.parse(response.body, symbolize_names:true)
    expect(revenue).to eq(5)
  end
end
