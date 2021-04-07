require 'rails_helper'

RSpec.describe "merchants API" do
  describe "happy path" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names:true)[:data]

      expect(merchants.count).to eq(3)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it "can paginate responses" do
      create_list(:merchant, 50)

      get '/api/v1/merchants?page=2&per_page=10'
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names:true)[:data]

      expect(merchants.count).to eq(10)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it "can paginate responses" do
      create_list(:merchant, 50)

      get '/api/v1/merchants?page=2'
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names:true)[:data]

      expect(merchants.count).to eq(20)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end
  describe "sad path" do
    it "sends page 1 of merchants if page is specified as 0" do
      create_list(:merchant, 30)

      get '/api/v1/merchants?page=0'
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names:true)[:data]

      expect(merchants.count).to eq(20)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
    it "If a user tries to fetch a page for which there is no data, then data should report an empty array" do
      create_list(:merchant, 30)

      get '/api/v1/merchants?page=8000000'
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names:true)[:data]

      expect(merchants.count).to eq(0)
      expect(merchants).to eq([])
    end
  end
  describe "show one merchant" do
    it "happy path" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"
      merchant = JSON.parse(response.body, symbolize_names:true)[:data]

      expect(response).to be_successful
      expect(merchant).to have_key(:id)
      # expect(merchant[:id]).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
    it "sad path" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"
      merchant = JSON.parse(response.body, symbolize_names:true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(404)
    end
  end
end
