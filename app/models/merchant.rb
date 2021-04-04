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
  end

  def self.merchants_by_items_sold
  end
end
