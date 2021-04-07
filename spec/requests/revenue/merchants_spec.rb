require 'rails_helper'

RSpec.describe "Merchant Revenue API" do
  it "returns the total revenue for a single merchant" do
    @merchant_7 = create(:merchant, name: 'Merchant 7')
    customer = create(:customer)
    item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 3.5)
    item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 1.5)
    invoice_1 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
    invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 3.5)
    InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 1.5)
    Transaction.create!(invoice_id: invoice_1.id, result: "success")
    Transaction.create!(invoice_id: invoice_2.id, result: "success")

    get "/api/v1/revenue/merchants/#{@merchant_7.id}"

    expect(response).to be_successful

    revenue = JSON.parse(response.body, symbolize_names:true)
    expect(revenue[:data][:attributes][:revenue]).to eq("5.0")
    expect(revenue[:data]).to have_key(:attributes)
  end
end
