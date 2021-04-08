require 'rails_helper'

RSpec.describe "Item's Merchant API" do
  describe "happy path" do
    it "sends a merchant object that owns the item" do
      merchant = create(:merchant)
      merchant2 = create(:merchant)
      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant2.id)

      get "/api/v1/items/#{item_1.id}/merchant"
      expect(response).to be_successful

      merchant_data = JSON.parse(response.body, symbolize_names:true)
      expect(merchant_data[:data][:attributes][:name]).to eq(merchant.name)
    end
  end
  describe "sad path" do
    it "sends a 404 error when a bad item id is sent" do
      merchant = create(:merchant)

      get "/api/v1/items/123457825689290/merchant"
      expect(response.status).to eq(404)

      merchant_data = JSON.parse(response.body, symbolize_names:true)
      expect(merchant_data[:data]).to eq(nil)
      expect(merchant_data[:errors]).to be_a(String)
    end
  end
  describe "edge case" do
    it "sends a 404 error when a bad item id is sent" do
      merchant = create(:merchant)

      get "/api/v1/items/string/merchant"
      expect(response.status).to eq(404)

      merchant_data = JSON.parse(response.body, symbolize_names:true)
      expect(merchant_data[:data]).to eq(nil)
      expect(merchant_data[:errors]).to be_a(String)
    end
  end
end
