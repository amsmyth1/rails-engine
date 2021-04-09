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
    it "returns the top potential revenue on x number of invoices" do
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
      InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_1.id, quantity: 1, unit_price: 5.5)
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

      expect(unshipped_revenue[:data].class).to eq(Array)
      expect(unshipped_revenue[:data].count).to eq(2)
      expect(unshipped_revenue[:data].first[:id].to_i).to eq(invoice_2.id)

      get "/api/v1/revenue/unshipped?quantity=1"

      expect(response).to be_successful

      unshipped_revenue = JSON.parse(response.body, symbolize_names:true)

      expect(unshipped_revenue[:data].class).to eq(Array)
      expect(unshipped_revenue[:data][0].count).to eq(3)
    end
  end

  describe ".revenue_by_date" do
    it "returans the total revenue in the system for a date range" do
      @merchant_7 = create(:merchant, name: 'Merchant 7')
      customer = create(:customer)
      item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 5)
      item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 5)
      invoice_1 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id, updated_at: Date.new(2021, 1, 25))
      invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id, updated_at: Date.new(2021, 1, 2))
      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 5)
      InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 2, unit_price: 5)
      Transaction.create!(invoice_id: invoice_1.id, result: "success")
      Transaction.create!(invoice_id: invoice_2.id, result: "success")

      @merchant_6 = create(:merchant, name: 'Merchant 6')
      customer6 = create(:customer)
      item_16 = @merchant_6.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 2)
      invoice_16 = Invoice.create!(customer_id: customer6.id, status: "shipped", merchant_id: @merchant_6.id, updated_at: Date.new(2021, 1, 20))
      invoice_26 = Invoice.create!(customer_id: customer6.id, status: "shipped", merchant_id: @merchant_6.id, updated_at: Date.new(2021, 2, 20))
      InvoiceItem.create!(invoice_id: invoice_16.id, item_id: item_16.id, quantity: 10, unit_price: 2)
      InvoiceItem.create!(invoice_id: invoice_26.id, item_id: item_16.id, quantity: 10, unit_price: 2)
      Transaction.create!(invoice_id: invoice_16.id, result: "success")
      Transaction.create!(invoice_id: invoice_26.id, result: "success")

      get "/api/v1/revenue?start=2021-01-01&end=2021-01-24"
      expect(response).to be_successful

      date_revenue = JSON.parse(response.body, symbolize_names:true)[:data]
      expect(date_revenue[:id]).to eq(nil)
      expect(date_revenue[:type]).to eq("revenue")
      expect(date_revenue[:attributes].count).to eq(1)
      expect(date_revenue[:attributes][:revenue]).to eq("40.0")
    end
  end
  describe "sad path" do
    it "returns an error is quantity is left blank" do
      get "/api/v1/revenue/merchants?quantity="
      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error is quantity is left blank" do
      get "/api/v1/revenue/merchants?quantity=asjf"
      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
  end

  describe "edge case" do
    it "returns an error is quantity is left blank" do
      get "/api/v1/revenue/merchants"

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when a bad merchant id is given for total_revenue" do
      get "/api/v1/revenue/merchants/8923987297"

      expect(response.status).to eq(404)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns and error when quantity is left blank for unshipped items" do
      get "/api/v1/revenue/unshipped?quantity="

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when no start or end dates are provided" do
      get "/api/v1/revenue"

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when no start date is provided" do
      get "/api/v1/revenue?end=2012-03-24"

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when no end date is provided" do
      get "/api/v1/revenue?start=2012-03-01"

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when start or end dates are blank" do
      get "/api/v1/revenue?start=&end="

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when start date is provided but end date is blank" do
      get "/api/v1/revenue?start=2012-03-01&end="

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when end date is provided but start date is blank" do
      get "/api/v1/revenue?start=&end=2012-03-24"

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
    it "returns an error when the end date is before the start date" do
      get "/api/v1/revenue?start=2100-01-01&end=2000-01-01"

      expect(response.status).to eq(400)
      revenue = JSON.parse(response.body, symbolize_names:true)
      expect(revenue[:error]).to be_a(String)
    end
  end
end
