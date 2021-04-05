require 'rails_helper'

RSpec.describe "merchants API" do
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

  it "can show one merchant" do
    id = create(:merchant).id

    get '/api/v1/merchants'
    merchant = JSON.parse(response.body, symbolize_names:true)[:data][0]

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    # expect(merchant[:id]).to be_an(Integer)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end
