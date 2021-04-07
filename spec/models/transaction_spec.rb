require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    it { should belong_to :invoice }
    it { should have_many(:invoice_items).through(:invoice) }
    it { should have_many(:items).through(:invoice) }
    it { should have_one(:customers).through(:invoice) }
  end

  describe "#total_revenue_by_date" do
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

      expect(Merchant.total_revenue_by_date(Date.new(2021, 1, 1), Date.new(2021, 1, 20))).to eq(BigDecimal.new(30))
      expect(Merchant.total_revenue_by_date(Date.new(2021, 1, 2), Date.new(2021, 1, 26))).to eq(BigDecimal.new(40))
      expect(Merchant.total_revenue_by_date(Date.new(2021, 2, 1), Date.new(2021, 2, 21))).to eq(BigDecimal.new(20))
      expect(Merchant.total_revenue_by_date(Date.new(2021, 1, 1), Date.new(2021, 12, 21))).to eq(BigDecimal.new(60))
    end
  end
end
