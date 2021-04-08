require 'rails_helper'

RSpec.describe "Merchant Items API" do
  describe "happy path" do
    it "sends a list of a merchants items" do
      merchant = create(:merchant)
      merchant2 = create(:merchant)
      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant.id)
      item_3 = create(:item, merchant_id: merchant.id)
      item_4 = create(:item, merchant_id: merchant.id)
      item_5 = create(:item, merchant_id: merchant.id)
      item_6 = create(:item, merchant_id: merchant2.id)
      item_7 = create(:item, merchant_id: merchant2.id)
      item_8 = create(:item, merchant_id: merchant2.id)
      item_9 = create(:item, merchant_id: merchant2.id)
      item_10 = create(:item, merchant_id: merchant2.id)
      item_11 = create(:item, merchant_id: merchant2.id)

      get "/api/v1/merchants/#{merchant.id}/items"
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names:true)[:data]
      expect(items.count).to eq(5)

      items.each do |item|
        expect(item).to have_key(:id)
        # expect(item[:id]).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(String)
      end
    end
  end
  describe "sad path" do
    it "sends a 404 if a bad id is sent" do
      get "/api/v1/merchants/123456789/items"
      expect(response.status).to eq(404)

      item = JSON.parse(response.body, symbolize_names:true)


      expect(item[:error]).to be_a(String)
    end
  end
end
