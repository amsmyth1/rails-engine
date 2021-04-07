class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :invoice_items, through: :invoice
  has_many :items, through: :invoice
  has_one :customers, through: :invoice

  def self.total_revenue_by_date(start_date, end_date)
    joins(:invoice_items)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .where('invoices.updated_at >= ?', start_date)
    .where('invoices.updated_at <= ?', (end_date + 1))
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price) as rev')
  end
end
