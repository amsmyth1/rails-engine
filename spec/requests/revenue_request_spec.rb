require 'rails_helper'

RSpec.describe "Revene Request" do
  describe "#merchant_revenue" do
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
  describe "#top_merchants" do
    it "returns the top x merchants names and revenue by top revenue earners" do
      @merchant_6 = create(:merchant, name: 'Merchant 6')
      customer6 = create(:customer)
      item_16 = @merchant_6.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 1.5)
      invoice_16 = Invoice.create!(customer_id: customer6.id, status: "shipped", merchant_id: @merchant_6.id)
      invoice_26 = Invoice.create!(customer_id: customer6.id, status: "shipped", merchant_id: @merchant_6.id)
      InvoiceItem.create!(invoice_id: invoice_16.id, item_id: item_16.id, quantity: 1, unit_price: 3.5)
      InvoiceItem.create!(invoice_id: invoice_26.id, item_id: item_16.id, quantity: 1, unit_price: 1.5)
      Transaction.create!(invoice_id: invoice_16.id, result: "success")
      Transaction.create!(invoice_id: invoice_26.id, result: "success")

      @merchant_7 = create(:merchant, name: 'Merchant 7')
      customer = create(:customer)
      item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 1.5)
      invoice_1 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
      invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 5.5)
      InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_1.id, quantity: 1, unit_price: 1.5)
      Transaction.create!(invoice_id: invoice_1.id, result: "success")
      Transaction.create!(invoice_id: invoice_2.id, result: "success")

      @merchant_8 = create(:merchant, name: 'Merchant 8')
      customer8 = create(:customer)
      item_18 = @merchant_8.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 1.5)
      invoice_18 = Invoice.create!(customer_id: customer8.id, status: "shipped", merchant_id: @merchant_8.id)
      invoice_28 = Invoice.create!(customer_id: customer8.id, status: "shipped", merchant_id: @merchant_8.id)
      InvoiceItem.create!(invoice_id: invoice_18.id, item_id: item_18.id, quantity: 1, unit_price: 1.5)
      InvoiceItem.create!(invoice_id: invoice_28.id, item_id: item_18.id, quantity: 1, unit_price: 1.5)
      Transaction.create!(invoice_id: invoice_18.id, result: "success")
      Transaction.create!(invoice_id: invoice_28.id, result: "success")


      get "/api/v1/revenue/merchants?quantity=10"

      expect(response).to be_successful

      revenue = JSON.parse(response.body, symbolize_names:true)

      expect(revenue[:data].class).to eq(Array)
      expect(revenue[:data].first.class).to eq(Hash)
      expect(revenue[:data].first[:attributes]).to have_key(:revenue)
      expect(revenue[:data].first[:attributes]).to have_key(:name)
    end
  end
  describe "#unshipped" do
    it "returns the top x merchants names and revenue by top revenue earners" do
      @merchant_6 = create(:merchant, name: 'Merchant 6')
      customer6 = create(:customer)
      item_16 = @merchant_6.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 1.5)
      invoice_16 = Invoice.create!(customer_id: customer6.id, status: "shipped", merchant_id: @merchant_6.id)
      invoice_26 = Invoice.create!(customer_id: customer6.id, status: "packaged", merchant_id: @merchant_6.id)
      InvoiceItem.create!(invoice_id: invoice_16.id, item_id: item_16.id, quantity: 1, unit_price: 3.5)
      InvoiceItem.create!(invoice_id: invoice_26.id, item_id: item_16.id, quantity: 1, unit_price: 1.5)
      Transaction.create!(invoice_id: invoice_16.id, result: "success")
      Transaction.create!(invoice_id: invoice_26.id, result: "success")

      @merchant_7 = create(:merchant, name: 'Merchant 7')
      customer = create(:customer)
      item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 1.5)
      invoice_1 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
      invoice_2 = Invoice.create!(customer_id: customer.id, status: "packaged", merchant_id: @merchant_7.id)
      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 5.5)
      InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_1.id, quantity: 1, unit_price: 1.5)
      Transaction.create!(invoice_id: invoice_1.id, result: "success")
      Transaction.create!(invoice_id: invoice_2.id, result: "success")

      @merchant_8 = create(:merchant, name: 'Merchant 8')
      customer8 = create(:customer)
      item_18 = @merchant_8.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 1.5)
      invoice_18 = Invoice.create!(customer_id: customer8.id, status: "shipped", merchant_id: @merchant_8.id)
      invoice_28 = Invoice.create!(customer_id: customer8.id, status: "shipped", merchant_id: @merchant_8.id)
      InvoiceItem.create!(invoice_id: invoice_18.id, item_id: item_18.id, quantity: 1, unit_price: 1.5)
      InvoiceItem.create!(invoice_id: invoice_28.id, item_id: item_18.id, quantity: 1, unit_price: 1.5)
      Transaction.create!(invoice_id: invoice_18.id, result: "success")
      Transaction.create!(invoice_id: invoice_28.id, result: "success")


      get "/api/v1/revenue/unshipped"

      expect(response).to be_successful

      unshipped_revenue = JSON.parse(response.body, symbolize_names:true)

      expect(unshipped_revenue).to eq(1)
    end
  end
end
