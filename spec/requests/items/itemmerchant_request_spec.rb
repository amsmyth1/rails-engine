require 'rails_helper'

RSpec.describe "Item's Merchant API" do
  it "sends a merchant object that owns the item" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant2.id)

    get "/api/v1/items/#{item_1.id}/merchant"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names:true)[:data]
    expect(merchant[:data][:attributes]).to eq(merchant.name)
  end
end
