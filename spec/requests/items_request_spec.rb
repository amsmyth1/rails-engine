require 'rails_helper'

RSpec.describe "Items API" do
  describe "happy path" do
    it "sends a list of items" do
      create_list(:item, 3)

      get '/api/v1/items'
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names:true)[:data]
      expect(items.count).to eq(3)

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
    it "can show one item" do
      id = create(:item).id

      get "/api/v1/items/#{id}"
      item = JSON.parse(response.body, symbolize_names:true)[:data]
      expect(response).to be_successful

      expect(item).to have_key(:id)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(String)
    end

    it "can create then delete an item" do
      merchant = create(:merchant)
      item_params = ({
        name: "Shiny Itemy Item",
        description: "It does a lot of things real good.",
        unit_price: 123.45,
        merchant_id: merchant.id
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      delete "/api/v1/items/#{created_item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find((created_item).id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can update an item" do
      id = create(:item).id

      previous_name = Item.last.name
      item_params = { name: "Test This Update!" }
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to eq("Test This Update!")
    end
  end
  describe "sad path" do
    it "sends a 404 error when a bad id is entered" do
      get "/api/v1/items/12564736473457"

      item = JSON.parse(response.body, symbolize_names:true)

      expect(response.status).to eq(404)
      expect(item[:data]).to eq(nil)
      expect(item[:error]).to be_a(String)
    end
    it "sends a 404 error when a bad id is entered to update an item" do
      put "/api/v1/items/12564736473457"

      item = JSON.parse(response.body, symbolize_names:true)

      expect(response.status).to eq(404)
      expect(item[:data]).to eq(nil)
      expect(item[:error]).to be_a(String)
    end
  end
  describe "edge case" do
    it "sends a 404 error when a bad id is entered" do
      get "/api/v1/items/string"

      item = JSON.parse(response.body, symbolize_names:true)

      expect(response.status).to eq(404)
      expect(item[:data]).to eq(nil)
      expect(item[:error]).to be_a(String)
    end
  end
end
