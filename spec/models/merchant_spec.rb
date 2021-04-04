require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should have_many :items }
  end

  describe "class methods" do
    describe "#total_revenue" do
      it "returans the total revenue for a merchant" do
        @merchant_7 = create(:merchant, name: 'Merchant 7')
        customer = create(:customer)
        item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10.5)
        item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20.5)
        invoice_1 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
        invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
        InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 3.5)
        InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 1.5)
        Transaction.create!(invoice_id: invoice_1.id, result: "success")
        Transaction.create!(invoice_id: invoice_2.id, result: "success")
        answer = BigDecimal.new(5)

        expect(Merchant.total_revenue(@merchant_7.id)).to eq(answer)
      end
    end

    describe "#total_revenue_by_date" do
      it "returans the total revenue for a merchant" do
        @merchant_7 = create(:merchant, name: 'Merchant 7')
        customer = create(:customer)
        item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10.5)
        item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20.5)
        invoice_1 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id, updated_at: Date.new(2021, 1, 25))
        invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id, updated_at: Date.new(2021, 1, 2))
        InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 3.5)
        InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 2, unit_price: 1.5)
        Transaction.create!(invoice_id: invoice_1.id, result: "success")
        Transaction.create!(invoice_id: invoice_2.id, result: "success")
        answer = BigDecimal.new(3)
        answer2 = BigDecimal.new(7)
        answer3 = BigDecimal.new(10)

        expect(Merchant.total_revenue_by_date(@merchant_7.id, Date.new(2021, 1, 24), Date.new(2021, 1, 26))).to eq(answer2)
        expect(Merchant.total_revenue_by_date(@merchant_7.id, Date.new(2021, 1, 2), Date.new(2021, 1, 4))).to eq(answer)
        expect(Merchant.total_revenue_by_date(@merchant_7.id, Date.new(2021, 1, 1), Date.new(2021, 1, 30))).to eq(answer3)
      end
    end

    describe "#total_revenue_by_month" do
      it "returans the total revenue for a merchant" do
        @merchant_7 = create(:merchant, name: 'Merchant 7')
        customer = create(:customer)
        item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 3.5)
        item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 1.5)
        invoice_1 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id, updated_at: Date.new(2021, 1, 25))
        invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id, updated_at: Date.new(2021, 2, 2))
        invoice_3 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id, updated_at: Date.new(2021, 2, 12))
        InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 3.5)
        InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 2, unit_price: 1.5)
        InvoiceItem.create!(invoice_id: invoice_3.id, item_id: item_1.id, quantity: 2, unit_price: 1.5)
        Transaction.create!(invoice_id: invoice_1.id, result: "success")
        Transaction.create!(invoice_id: invoice_2.id, result: "success")
        Transaction.create!(invoice_id: invoice_3.id, result: "success")
        answer = [[Time.new(2021), Time.new(2021, 1), BigDecimal.new(7)],[Time.new(2021), Time.new(2021, 2), BigDecimal.new(6)]]

        expect(Merchant.revenue_by_top_month(@merchant_7.id).first[2]).to eq(BigDecimal.new(7))
        expect(Merchant.revenue_by_top_month(@merchant_7.id)[1][2]).to eq(BigDecimal.new(6))
      end
    end
  end
end
