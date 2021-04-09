require 'rails_helper'

RSpec.describe "Search Request" do
  describe "#find_one_merchant" do
    it "find a single merchant which matches a search term" do
      merchant_1 = create(:merchant, name: "William")
      merchant_2 = create(:merchant, name: "will")
      merchant_3 = create(:merchant, name: "Bill")
      merchant_4 = create(:merchant, name: "billy")
      merchant_5 = create(:merchant, name: "Billie")
      merchant_6 = create(:merchant, name: "Wilma")

      get "/api/v1/merchants/find?name=iLl"
      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names:true)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to eq(merchant_1.name)
    end
    it "return an empty hash when nothing matches" do
      merchant_1 = create(:merchant, name: "William")
      merchant_2 = create(:merchant, name: "will")
      merchant_3 = create(:merchant, name: "Bill")
      merchant_4 = create(:merchant, name: "billy")
      merchant_5 = create(:merchant, name: "Billie")
      merchant_6 = create(:merchant, name: "Wilma")

      get "/api/v1/merchants/find?name=ABCd"
      expect(response.status).to eq(400)

      merchant = JSON.parse(response.body, symbolize_names:true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data].count).to eq(0)
    end
  end

  describe "#find_all_merchants_by_name" do
    it "find all merchants which match a search term" do
      merchant_1 = create(:merchant, name: "William")
      merchant_2 = create(:merchant, name: "will")
      merchant_3 = create(:merchant, name: "Bill")
      merchant_4 = create(:merchant, name: "billy")
      merchant_5 = create(:merchant, name: "Billie")
      merchant_6 = create(:merchant, name: "Wilma")

      get "/api/v1/merchants/find_all?name=iLl"

      expect(response.status).to eq(200)
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names:true)
binding.pry
      expect(merchants[:data]).to be_a(Hash)
      expect(merchants[:data].count).to eq(0)
    end

    it "return an empty hash when nothing matches" do
      merchant_1 = create(:merchant, name: "William")
      merchant_2 = create(:merchant, name: "will")
      merchant_3 = create(:merchant, name: "Bill")
      merchant_4 = create(:merchant, name: "billy")
      merchant_5 = create(:merchant, name: "Billie")
      merchant_6 = create(:merchant, name: "Wilma")

      get "/api/v1/merchants/find_all?name=ABCd"
      expect(response.status).to eq(400)

      merchant = JSON.parse(response.body, symbolize_names:true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data].count).to eq(0)
    end
  end

  describe "#find_all_items" do
    it "should return items that match a query name" do
      item_1 = create(:item, name: "THE")
      item_2 = create(:item, name: "there")
      item_3 = create(:item, name: "either")
      item_4 = create(:item, name: "wtihe")
      item_5 = create(:item, name: "we")
      item_6 = create(:item, name: "AtHe")

      get "/api/v1/items/find_all?name=tHe"
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names:true)

      expect(items[:data].count).to eq(4)
    end
    it "should return an empty array when no items match a query" do
      item_1 = create(:item, name: "THE")
      item_2 = create(:item, name: "there")
      item_3 = create(:item, name: "either")
      item_4 = create(:item, name: "wtihe")
      item_5 = create(:item, name: "we")
      item_6 = create(:item, name: "AtHe")

      get "/api/v1/items/find_all?name=WaTEr"
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names:true)

      expect(items[:data]).to eq([])
    end
  end
  describe "Find one item by price" do
    it "returns one item that have prices within the search, sorted alhpabetically" do
      item_1 = create(:item, unit_price: 10.0, name: "D")
      item_2 = create(:item, unit_price: 20.0, name: "C")
      item_3 = create(:item, unit_price: 30.0, name: "B")
      item_4 = create(:item, unit_price: 40.0, name: "A")
      item_5 = create(:item, unit_price: 50.0, name: "F")
      item_6 = create(:item, unit_price: 60.0, name: "E")

      get "/api/v1/items/find?max_price=40"
      expect(response).to be_successful
      expect(response.status).to eq(200)
      item = JSON.parse(response.body, symbolize_names:true)


      expect(item.count).to eq(1)
      expect(item[:data][:id]).to eq(item_4.id.to_s)
      expect(item[:data][:attributes][:name]).to eq(item_4.name)
    end
    it "returns sucess but no data if min price is too big" do
      item_1 = create(:item, unit_price: 10.0, name: "D")
      item_2 = create(:item, unit_price: 20.0, name: "C")
      item_3 = create(:item, unit_price: 30.0, name: "B")
      item_4 = create(:item, unit_price: 40.0, name: "A")
      item_5 = create(:item, unit_price: 50.0, name: "F")
      item_6 = create(:item, unit_price: 60.0, name: "E")

      get "/api/v1/items/find?min_price=400000"
      expect(response).to be_successful
      expect(response.status).to eq(200)
      item = JSON.parse(response.body, symbolize_names:true)


      expect(item.count).to eq(1)
      expect(item[:data]).to be_a(Hash)
      expect(item[:data].empty?).to eq(true)
    end
    it "returns 400 if min price is less than 0" do
      item_1 = create(:item, unit_price: 10.0, name: "D")
      item_2 = create(:item, unit_price: 20.0, name: "C")
      item_3 = create(:item, unit_price: 30.0, name: "B")
      item_4 = create(:item, unit_price: 40.0, name: "A")
      item_5 = create(:item, unit_price: 50.0, name: "F")
      item_6 = create(:item, unit_price: 60.0, name: "E")

      get "/api/v1/items/find?min_price=-10"
      # expect(response).to be_successful
      expect(response.status).to eq(400)
      item = JSON.parse(response.body, symbolize_names:true)


      expect(item.count).to eq(1)
      expect(item[:data]).to eq(nil)
      expect(item[:error]).to be_a(String)
    end
    it "returns 400 if max price is less than 0" do
      item_1 = create(:item, unit_price: 10.0, name: "D")
      item_2 = create(:item, unit_price: 20.0, name: "C")
      item_3 = create(:item, unit_price: 30.0, name: "B")
      item_4 = create(:item, unit_price: 40.0, name: "A")
      item_5 = create(:item, unit_price: 50.0, name: "F")
      item_6 = create(:item, unit_price: 60.0, name: "E")

      get "/api/v1/items/find?max_price=-10"
      # expect(response).to be_successful
      expect(response.status).to eq(400)
      item = JSON.parse(response.body, symbolize_names:true)


      expect(item.count).to eq(1)
      expect(item[:data]).to eq(nil)
      expect(item[:error]).to be_a(String)
    end
  end
  describe "#find_one_merchnat - edge cases" do
    it "returns an error when no name parameter passed" do
      get "/api/v1/merchants/find"
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names:true)

      expect(item.count).to eq(2)
      expect(item[:data]).to eq({})
      expect(item[:error]).to be_a(String)
    end
    it "returns an error when no nothing is passed to the name parameter" do
      get "/api/v1/merchants/find?name="
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names:true)

      expect(item.count).to eq(2)
      expect(item[:data]).to eq({})
      expect(item[:error]).to be_a(String)
    end
  end
  describe "#find_all_items - edge cases" do
    it "returns an error when no name parameter is passed " do
      get "/api/v1/items/find_all"
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names:true)

      expect(item.count).to eq(1)
      expect(item[:data]).to eq(nil)
      expect(item[:error]).to be_a(String)

    end
    it "returns an error when no nothing is passed to the name parameter" do
      get "/api/v1/items/find_all?name="
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names:true)

      expect(item.count).to eq(1)
      expect(item[:data]).to eq(nil)
      expect(item[:error]).to be_a(String)

    end
  end
  describe "find_one_item_by_price - edge cases" do
    it "returns an error when no mimumum price is passed to the min_price parameter" do
      get "http://localhost:3000/api/v1/items/find?min_price="
      expect(response.status).to eq(400)

      items = JSON.parse(response.body, symbolize_names:true)

      expect(items.count).to eq(1)
      expect(items[:data]).to eq(nil)
      expect(items[:error]).to be_a(String)
    end
    it "returns an error when no maxium price is passed to the max_price parameter" do
      get "http://localhost:3000/api/v1/items/find?max_price="

      expect(response.status).to eq(400)

      items = JSON.parse(response.body, symbolize_names:true)

      expect(items.count).to eq(1)
      expect(items[:data]).to eq(nil)
      expect(items[:error]).to be_a(String)
    end
    it "returns an error when min price is over max price" do
      get "/api/v1/items/find?min_price=50&max_price=5"

      expect(response.status).to eq(400)

      items = JSON.parse(response.body, symbolize_names:true)

      expect(items.count).to eq(1)
      expect(items[:data]).to eq(nil)
      expect(items[:error]).to be_a(String)
    end
  end
end
