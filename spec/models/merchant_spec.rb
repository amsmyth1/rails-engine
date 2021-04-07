require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "class methods" do
    describe "#total_revenue" do
      it "returns the total revenue for a merchant" do
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
    describe "#total_revenue_of_unshipped_items" do
      it "returns the total revenue for a merchant" do
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

        expect(Merchant.total_revenue_of_unshipped_items[0].class).to eq(Merchant)
      end
    end

    describe "#top_merchants_by_total_revenue(limit)" do
      it "returns the top merchants based on total_revenue" do
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



        expect(Merchant.top_merchants_by_total_revenue(3)).to eq([@merchant_7, @merchant_6, @merchant_8])
        expect(Merchant.top_merchants_by_total_revenue(2)).to eq([@merchant_7, @merchant_6])
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

        expect(Merchant.total_revenue_by_date(Date.new(2021, 1, 24), Date.new(2021, 1, 26))).to eq(answer2)
        expect(Merchant.total_revenue_by_date(Date.new(2021, 1, 2), Date.new(2021, 1, 4))).to eq(answer)
        expect(Merchant.total_revenue_by_date(Date.new(2021, 1, 1), Date.new(2021, 1, 30))).to eq(answer3)
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

        expect(Merchant.revenue_by_month.first[2]).to eq(BigDecimal.new(7))
        expect(Merchant.revenue_by_month[1][2]).to eq(BigDecimal.new(6))
      end
    end

    describe ".paginate" do
      it "takes arguments for page and per_page to display results" do
        answer = Merchant.paginate(page: 3, per_page: 2)

        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)
        merchant_4 = create(:merchant)
        merchant_5 = create(:merchant)
        merchant_6 = create(:merchant)

        expect(answer).to eq([merchant_5, merchant_6])
      end
    end

    describe ".find_one" do
      it "find a single merchant which matches a search term" do
        merchant_1 = create(:merchant, name: "William")
        merchant_2 = create(:merchant, name: "will")
        merchant_3 = create(:merchant, name: "Bill")
        merchant_4 = create(:merchant, name: "billy")
        merchant_5 = create(:merchant, name: "Billie")
        merchant_6 = create(:merchant, name: "Wilma")

        expect(Merchant.find_one("ill")).to eq([merchant_1])
      end
    end
  end
end
