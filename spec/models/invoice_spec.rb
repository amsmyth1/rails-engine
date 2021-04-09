require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe "::class methods" do
    describe "::potential_revenue" do
      it "calculates the potential revenue of the invoices" do
        @merchant_7 = create(:merchant, name: 'Merchant 7')
        customer = create(:customer)
        item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10.5)
        item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20.5)
        invoice_1 = Invoice.create!(customer_id: customer.id, status: "packaged", merchant_id: @merchant_7.id)
        invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
        InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 3.5)
        InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 1.5)
        Transaction.create!(invoice_id: invoice_1.id, result: "success")
        Transaction.create!(invoice_id: invoice_2.id, result: "success")

        expect(Invoice.potential_revenue(1)).to eq([invoice_1])
        expect(Invoice.potential_revenue(1).pluck('sum(invoice_items.quantity * invoice_items.unit_price) as rev')).to eq([BigDecimal.new(7)])

      end
    end
    describe "::delete_if_only_item" do
      it "should delete any invoices that have only that deleted item" do
        @merchant_7 = create(:merchant, name: 'Merchant 7')
        customer = create(:customer)
        item_1 = @merchant_7.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10.5)
        item_2 = @merchant_7.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 20.5)
        invoice_1 = Invoice.create!(customer_id: customer.id, status: "packaged", merchant_id: @merchant_7.id)
        invoice_2 = Invoice.create!(customer_id: customer.id, status: "shipped", merchant_id: @merchant_7.id)
        InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 3.5)
        InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 1.5)
        Transaction.create!(invoice_id: invoice_1.id, result: "success")
        Transaction.create!(invoice_id: invoice_2.id, result: "success")
        Invoice.delete_if_only_item(item_1.id)

        expect(Invoice.all).to eq([invoice_2])
      end
    end
  end
end
