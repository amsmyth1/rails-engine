class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.total_revenue(merchant_id)
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .where(id: merchant_id)
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price) as rev')[0]
  end

  def self.total_revenue_by_date(merchant_id, start_date, end_date)
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .where('invoices.updated_at >= ?', start_date)
    .where('invoices.updated_at <= ?', end_date)
    .where(id: merchant_id)
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price) as rev')[0]

    # sequel ("SELECT sum(invoice_items.quantity * invoice_items.unit_price) as rev FROM "merchants" INNER JOIN "items" ON "items"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."item_id" = "items"."id" INNER JOIN "invoices" ON "invoices"."id" = "invoice_items"."invoice_id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE (transactions.result = 'success') AND (invoices.status = 'shipped') AND (invoices.updated_at > '2012-03-01') AND (invoices.updated_at < '2012-03-26') AND "merchants"."id" = 1;")
  end
end
